local binaries = {}

return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ binaries[config.root_dir], '--lsp', '--stdio' }, dispatchers)
  end,
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { 'package-lock.json', 'pnpm-lock.yaml', 'yarn.lock', 'bun.lock', 'package.json', 'tsconfig.json' })
      or vim.fs.root(bufnr, { '.git' })
      or vim.fn.getcwd()
    local candidates = {
      vim.fs.joinpath(root, 'node_modules', '.bin', 'tsc'),
      vim.fn.exepath('tsc'),
    }

    for _, candidate in ipairs(candidates) do
      if candidate ~= '' and vim.fn.executable(candidate) == 1 then
        local result = vim.system({ candidate, '--version' }, { text = true }):wait()
        local version = vim.version.parse(result.stdout or '')
        if result.code == 0 and version and version.major >= 7 then
          binaries[root] = candidate
          on_dir(root)
          return
        end
      end
    end
  end,
  settings = {
    ['js/ts'] = {
      inlayHints = {
        parameterNames = { enabled = 'literals', suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
