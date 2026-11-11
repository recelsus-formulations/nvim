return {
  {
    -- Neovim 0.11+ native LSP config/enable
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_enable = false,
      })

      -- Global diagnostic keymaps
      vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = "lsp: diag float", noremap = true, silent = true })
      vim.keymap.set('n', '[d', function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "lsp: prev diag", noremap = true, silent = true })
      vim.keymap.set('n', ']d', function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "lsp: next diag", noremap = true, silent = true })

      vim.api.nvim_create_autocmd('WinNew', {
        callback = function()
          local win_id = vim.api.nvim_get_current_win()
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win_id) then return end
            local ok, source_bufnr = pcall(vim.api.nvim_win_get_var, win_id, 'textDocument/hover')
            if not ok or not vim.api.nvim_buf_is_valid(source_bufnr) then return end
            if vim.api.nvim_get_current_buf() ~= source_bufnr then return end

            local hover_bufnr = vim.api.nvim_win_get_buf(win_id)
            vim.keymap.set('n', '<Esc>', function()
              if vim.api.nvim_win_is_valid(win_id) then
                vim.api.nvim_win_close(win_id, true)
              end
            end, { buffer = hover_bufnr, silent = true, desc = 'lsp: close hover' })

            local function open_hover_split(split_cmd)
              local lines = vim.api.nvim_buf_get_lines(hover_bufnr, 0, -1, false)
              local cursor = vim.api.nvim_win_get_cursor(win_id)
              local split_bufnr = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(split_bufnr, 0, -1, false, lines)
              vim.bo[split_bufnr].filetype = vim.bo[hover_bufnr].filetype
              vim.bo[split_bufnr].modifiable = false

              for _, source_win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_buf(source_win) == source_bufnr then
                  vim.api.nvim_set_current_win(source_win)
                  break
                end
              end
              if vim.api.nvim_win_is_valid(win_id) then
                vim.api.nvim_win_close(win_id, true)
              end
              vim.cmd(split_cmd)
              vim.api.nvim_win_set_buf(0, split_bufnr)
              vim.api.nvim_win_set_cursor(0, cursor)
            end

            vim.keymap.set('n', '<C-v>', function()
              open_hover_split('vsplit')
            end, { buffer = hover_bufnr, silent = true, desc = 'lsp: hover vertical split' })
            vim.keymap.set('n', '<C-x>', function()
              open_hover_split('split')
            end, { buffer = hover_bufnr, silent = true, desc = 'lsp: hover horizontal split' })
            vim.api.nvim_set_current_win(win_id)
          end)
        end,
      })

      -- Buffer-local LSP setup via LspAttach (Neovim 0.11+ style)
      local aug = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = aug,
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- omnifunc for completion fallback
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local function buf_map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          local function supports(method)
            if not client then return false end
            if type(client.supports_method) == 'function' then
              local ok, supported = pcall(client.supports_method, client, method, bufnr)
              if ok then return supported end
              ok, supported = pcall(client.supports_method, client, method)
              if ok then return supported end
            end
            return false
          end

          local function hover()
            local diagnostic_bufnr, diagnostic_win = vim.diagnostic.open_float({
              scope = 'line',
              border = 'rounded',
              focusable = true,
              max_width = 120,
              max_height = 30,
              title = ' LSP Diagnostics ',
              title_pos = 'center',
            })
            if diagnostic_win then
              vim.keymap.set('n', '<Esc>', function()
                if vim.api.nvim_win_is_valid(diagnostic_win) then
                  vim.api.nvim_win_close(diagnostic_win, true)
                end
              end, { buffer = diagnostic_bufnr, silent = true, desc = 'lsp: close diagnostics' })
              vim.api.nvim_set_current_win(diagnostic_win)
              return
            end

            vim.lsp.buf.hover({
              border = 'rounded',
              focusable = true,
              max_width = 120,
              max_height = 30,
              title = ' LSP Hover ',
              title_pos = 'center',
            })
          end

          local function type_definition_in_split(split_cmd)
            vim.lsp.buf.type_definition({
              on_list = function(options)
                if not options.items or vim.tbl_isempty(options.items) then
                  vim.notify('No type definition found', vim.log.levels.INFO)
                  return
                end

                vim.fn.setqflist({}, ' ', {
                  title = options.title or 'LSP type definition',
                  items = options.items,
                })
                vim.cmd(split_cmd)
                vim.cmd.cfirst()
              end,
            })
          end

          buf_map('n', 'K', hover, 'lsp: hover')

          -- LSP navigation/utilities
          if supports('textDocument/definition') then
            buf_map('n', '<leader>ld', vim.lsp.buf.definition, 'lsp: definition')
          end
          if supports('textDocument/declaration') then
            buf_map('n', '<leader>lD', vim.lsp.buf.declaration, 'lsp: declaration')
          end
          if supports('textDocument/typeDefinition') then
            buf_map('n', '<leader>lt', vim.lsp.buf.type_definition, 'lsp: type definition')
            buf_map('n', '<leader>lx', function()
              type_definition_in_split('split')
            end, 'lsp: type definition split')
            buf_map('n', '<leader>lv', function()
              type_definition_in_split('vsplit')
            end, 'lsp: type definition vsplit')
          end
          if supports('textDocument/implementation') then
            buf_map('n', '<leader>lm', vim.lsp.buf.implementation, 'lsp: implementation')
          end
          if supports('textDocument/references') then
            buf_map('n', '<leader>lR', vim.lsp.buf.references, 'lsp: references')
          end
          if supports('textDocument/signatureHelp') then
            buf_map('n', '<leader>ls', vim.lsp.buf.signature_help, 'lsp: signature')
          end
          if supports('textDocument/rename') then
            buf_map('n', '<leader>lr', vim.lsp.buf.rename, 'lsp: rename')
          end
          if supports('textDocument/codeAction') then
            buf_map('n', '<leader>la', vim.lsp.buf.code_action, 'lsp: action')
          end
          if supports('textDocument/formatting') then
            buf_map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'lsp: format')
          end

          -- Enable inlay hints by default if supported; add toggle
          if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
            local ih = vim.lsp.inlay_hint
            local function ih_enable(buf, enable)
              if ih and ih.enable then
                if pcall(ih.enable, enable, { bufnr = buf }) then return true end
                if pcall(ih.enable, buf, enable) then return true end
              end
              if type(ih) == 'function' then
                return pcall(ih, buf, enable)
              end
              return false
            end
            local function ih_is_enabled(buf)
              if ih and ih.is_enabled then
                local ok, val = pcall(ih.is_enabled, { bufnr = buf })
                if ok and type(val) == 'boolean' then return val end
                ok, val = pcall(ih.is_enabled, buf)
                if ok and type(val) == 'boolean' then return val end
              end
              return false
            end

            ih_enable(bufnr, true)

            buf_map('n', '<leader>li', function()
              local cur = ih_is_enabled(bufnr)
              ih_enable(bufnr, not cur)
            end, 'lsp: inlay toggle')
          end
        end,
      })

      -- Centralize completion capabilities for all servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('blink.cmp').get_lsp_capabilities()
      )
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Enable installed servers that have lua/lsp/servers/<name>.lua.
      local lsp_servers = require('lsp')
      local installed = {}
      for _, s in ipairs(require('mason-lspconfig').get_installed_servers()) do
        installed[s] = true
      end

      for _, server in ipairs(lsp_servers.configs()) do
        if server.name == 'tsc' or installed[server.name] then
          vim.lsp.config(server.name, server.config)
          vim.lsp.enable(server.name)
        end
      end
    end,
  },
}
