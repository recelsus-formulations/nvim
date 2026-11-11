# Dependencies

`fzf` `ripgrep` `nodejs` `npm` `cmake` `make` `tree-sitter-cli`

Most language servers are installed via Mason. TypeScript 7 is resolved from the project or `PATH`:
- TypeScript: `typescript` 7+ (`tsc --lsp --stdio`)
- C/C++: `clangd`
- Bash: `bash-language-server`
- Lua: `lua-language-server`

# Keymap List

### LSP Related Operations
- `<leader>le`: Show diagnostics for the current cursor position in a popup
- `[d`: Go to the previous diagnostic message
- `]d`: Go to the next diagnostic message
- `K`: Show all diagnostics on the current line from any cursor position, or LSP hover if none; focus the popup, scroll with `j`/`k` or `<C-d>`/`<C-u>`, and close with `<Esc>`
- `<C-v>` / `<C-x>` (in LSP hover): Open the hover text in a vertical / horizontal split
- `<leader>ld`: Jump to definition
- `<leader>lD`: Jump to declaration, when supported by the server
- `<leader>lt`: Jump to type definition
- `<leader>lx`: Open type definition in a horizontal split
- `<leader>lv`: Open type definition in a vertical split
- `<leader>lm`: Jump to implementation
- `<leader>lR`: Find references
- `<leader>ls`: Show signature help
- `<leader>li`: Toggle inlay hints, when supported by the server
- `<leader>lr`: Rename symbol
- `<leader>la`: Code action
- `<leader>lf`: Format buffer
- `<leader>lp`: Preview type definition without leaving the current buffer

### Completion Related Operations
- `<C-d>`: Scroll documentation up (4 lines)
- `<C-f>`: Scroll documentation down (4 lines)
- `<C-s>`: Start completion
- `<CR>`: Select and confirm completion candidate
- `<C-n>`: Go to the next completion candidate
- `<C-p>`: Go to the previous completion candidate
- Completion documentation is shown automatically in a rounded floating window.
- Cmdline completion opens automatically for command-line mode.

### Translate Related Operations
- `<leader>td` (normal): Translate diagnostic under the cursor
- `<leader>tc` (normal): Translate the current comment line
- `<leader>tw` (normal): Translate the word under the cursor
- `<leader>tt` (normal): Translate by context: diagnostic, then comment, then word
- `<leader>tt` (visual): Translate selected text
- `<leader>td` (visual): Translate selected text, kept for compatibility
- `<leader>tr` (visual): Translate selected text and replace it

### hlslens Related Operations
- `n`: Move to the next search result and display `hlslens` highlights
- `N`: Move to the previous search result and display `hlslens` highlights
- `*`: Search for the word under the current cursor and display `hlslens` highlights
- `#`: Search for the word under the current cursor in reverse and display `hlslens` highlights
- `g*`: Search for partially matching words and display `hlslens` highlights
- `g#`: Search for partially matching words in reverse and display `hlslens` highlights

### Telescope Related Operations
- `<leader>ff`: Find files (`Telescope find_files`)
- `<leader>fg`: Search text (`Telescope live_grep`)
- `<leader>fb`: Show buffer list (`Telescope buffers`)
- `<leader>fh`: Search help tags (`Telescope help_tags`)
- `<leader>fk`: Show keymap list (`builtin.keymaps`)

### Git/Diff Related Operations
- `<leader>gb`: Toggle current line blame
- `<leader>gd`: Show current file diff via gitsigns
- `<leader>gD`: Open Diffview for current working tree changes
- `<leader>gM`: Open Diffview against the default branch ref (`origin/HEAD`, `main`, `master`, or `HEAD~1`)
- `<leader>gC`: Close Diffview
- `<leader>gT`: Toggle Diffview file panel
- `<leader>gF`: Show current file history
- `<leader>gH`: Show repository file history
- `<leader>gs`: Open fugitive Git status
- `<leader>gv`: Open current file diff in a vertical split
- `<leader>gx`: Open current file diff in a horizontal split

## Configuration Structure

- Plugin manager: `lazy.nvim` (`init.lua`)
- Global editor settings & diagnostics: `lua/config/config.lua`
- Environment file loading: `lua/config/env.lua`
- LSP core (Mason + native LSP + LspAttach mappings): `lua/plugins/nvim-lsp.lua`
- Completion (blink.cmp) setup: `lua/plugins/cmp.lua`
- Tree-sitter parser manager: `lua/plugins/nvim-treesitter.lua`
- Native Tree-sitter startup: `lua/config/treesitter.lua`
- Git diff/review helpers: `lua/plugins/git-diff.lua`
- Per-language LSP definitions: `lua/lsp/servers/*.lua`

### LSP Behavior (Neovim 0.11 style)
- LSP servers are installed with Mason and enabled via Neovim's native API (`vim.lsp.config` / `vim.lsp.enable`).
- Only installed servers with a matching `lua/lsp/servers/<server>.lua` definition are enabled.
- Buffer-local keymaps and `omnifunc` are set on `LspAttach`.
- LSP keymaps are created only when the attached server advertises the matching capability.
- Inlay hints are enabled by default when supported and can be toggled via `<leader>li`.
- Global diagnostics UI is configured once in `lua/config/config.lua`.

### Per-language LSP Definitions
Place a file under `lua/lsp/servers/<server>.lua` that returns the complete server config, including `cmd`, `filetypes`, and `root_markers`.

Provided examples:
- TypeScript (tsc): `lua/lsp/servers/tsc.lua`
- C/C++ (clangd): `lua/lsp/servers/clangd.lua`
- Bash (bashls): `lua/lsp/servers/bashls.lua`
- Lua (lua_ls): `lua/lsp/servers/lua_ls.lua`
- Go (gopls): `lua/lsp/servers/gopls.lua`

### Completion (blink.cmp)
- Lives in `lua/plugins/cmp.lua` and is independent from the LSP plugin.
- Snippet support uses blink.cmp's built-in snippet source with `friendly-snippets`.
- Sources: `lsp`, `path`, `snippets`, `buffer`.
- Completion menu selection and documentation floats are styled explicitly for higher contrast/readability.
- Cmdline mode uses blink.cmp as well. The menu is shown automatically instead of requiring `<Tab>` first.

### Tree-sitter
- Parser installation is managed by `neovim-treesitter/nvim-treesitter` plus `treesitter-parser-registry`.
- Runtime highlighting/folding uses Neovim's native `vim.treesitter.*` APIs.
- Parsers are installed intentionally per language rather than through the old monolithic nvim-treesitter module setup.
- Plugin install does not auto-run `:TSUpdate`; parser updates are done intentionally when needed.

### LSP Test Files
- `test/ts/*.ts` and `test/cpp/*.{hpp,cpp}` are small snake_case samples for checking hover, definition, type definition, split jumps, references, and completion behavior.

### Git Diff Tools
- `gitsigns.nvim` handles inline signs, blame, and quick current-file hunk/diff checks.
- `diffview.nvim` provides a left file panel and side-by-side diff layout for working tree, branch, and history review.
- `vim-fugitive` provides Git status and split diff commands for the current file.

## Extra Utilities

- Environment overrides:
  - Config-root `.env` is loaded automatically at startup and can override or add environment variables for this Neovim config.
  - `.env.example` documents the expected local variables. Copy it to `.env` for machine-local values.
  - `:EnvLoad`: search for `.env` upward from the directory where Neovim was started, then load it manually.
  - `:EnvLoad path/to/file.env`: load the specified env file manually.
  - Implementation: `lua/config/env.lua`
- Yank diagnostics and code lines:
  - `<leader>yd`: Yank current line + topmost diagnostic under cursor
  - `<leader>yad`: Yank entire buffer, then list lines with diagnostics
  - `<leader>ys` (visual): Yank selected block, then list diagnostics in selection
  - Implementations: `lua/config/yank.lua`
- Translate diagnostics, comments, words, or visual selection. Requires `GEMINI_API_KEY` and `GEMINI_MODEL`:
  - `<leader>td` (normal): diagnostic
  - `<leader>tc` (normal): current comment line
  - `<leader>tw` (normal): word under cursor
  - `<leader>tt` (normal): diagnostic/comment/word by context
  - `<leader>tt` / `<leader>td` (visual): selected text
  - `<leader>tr` (visual): replace selected text with translation
  - Implementation: `lua/config/ai/translate.lua`
- Show `:messages` in a split:
  - `<leader>ms`
  - Implementation: `lua/config/message.lua`
- Insert shell command output below the current line:
  - `<leader>si`: prompt for a command and insert its output
  - `:ShellInsert git status`
  - Implementation: `lua/config/shell_insert.lua`

## Built-in Alternatives

- `:read !cmd`: insert command output below the current line
- `:%!cmd`: replace the whole buffer with command output
- `:'<,'>!cmd`: filter the selected range through a command
- Examples: `:read !ls`, `:%!sort`, `:'<,'>!jq .`

## Notes

- `.env` and `.env.*` are ignored by VCS; `.env.example` is tracked as a template.
- `lazy-lock.json` is ignored (not tracked). If you want to pin plugin versions, remove it from `.gitignore` locally.
