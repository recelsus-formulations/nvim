# 依存関係

`fzf` `ripgrep` `nodejs` `npm` `cmake` `make` `tree-sitter-cli`

LSP サーバーは主に Mason でインストールします。TypeScript 7 はプロジェクト内または `PATH` から取得します:
- TypeScript: `typescript` 7+ (`tsc --lsp --stdio`)
- C/C++: `clangd`
- Bash: `bash-language-server`
- Lua: `lua-language-server`

# キーマップ一覧

## LSP 関連
- `<leader>le`: 現在行の診断メッセージをポップアップで表示
- `[d`: 直前の診断へ移動
- `]d`: 次の診断へ移動
- `K`: カーソル位置によらず現在行の診断をすべて表示。診断がなければ LSP Hover を表示。フロートにフォーカスし、`j`/`k` または `<C-d>`/`<C-u>` でスクロール、`<Esc>` で閉じる
- `<C-v>` / `<C-x>`（LSP Hover 内）: Hover の内容を縦分割 / 横分割で開く
- `<leader>ld`: 定義へ移動
- `<leader>lD`: 宣言へ移動（サーバーが対応している場合）
- `<leader>lt`: 型定義へ移動
- `<leader>lx`: 型定義を水平分割で開く
- `<leader>lv`: 型定義を垂直分割で開く
- `<leader>lm`: 実装へ移動
- `<leader>lR`: 参照を検索
- `<leader>ls`: シグネチャヘルプ表示
- `<leader>li`: Inlay Hints の切り替え（サーバーが対応している場合）
- `<leader>lr`: リネーム
- `<leader>la`: コードアクション
- `<leader>lf`: フォーマット
- `<leader>lp`: 現在バッファに残ったまま型定義をプレビュー

## 補完
- `<C-d>`: ドキュメントを上に 4 行スクロール
- `<C-f>`: ドキュメントを下に 4 行スクロール
- `<C-s>`: 補完メニューを開く
- `<CR>`: 補完候補を確定
- `<C-n>`: 次の補完候補へ
- `<C-p>`: 前の補完候補へ
- 補完ドキュメントは rounded border のフロートで自動表示
- cmdline 補完はコマンドラインモードで自動表示

## 翻訳
- `<leader>td`（ノーマル）: カーソル位置の診断を翻訳
- `<leader>tc`（ノーマル）: 現在行のコメント本文を翻訳
- `<leader>tw`（ノーマル）: カーソル下の単語を翻訳
- `<leader>tt`（ノーマル）: 診断、コメント、単語の順で文脈翻訳
- `<leader>tt`（ビジュアル）: 選択範囲を翻訳
- `<leader>td`（ビジュアル）: 選択範囲を翻訳（互換用）
- `<leader>tr`（ビジュアル）: 選択範囲を翻訳して置換

## Telescope
- `<leader>ff`: ファイル検索（`Telescope find_files`）
- `<leader>fg`: テキスト検索（`Telescope live_grep`）
- `<leader>fb`: バッファ一覧（`Telescope buffers`）
- `<leader>fh`: ヘルプタグ検索（`Telescope help_tags`）
- `<leader>fk`: キーマップ検索（`builtin.keymaps`）

## Git/Diff 関連
- `<leader>gb`: 現在行 blame の切り替え
- `<leader>gd`: gitsigns で現在ファイルの diff を表示
- `<leader>gD`: 現在の作業ツリー差分を Diffview で開く
- `<leader>gM`: default branch 相当の ref（`origin/HEAD`, `main`, `master`, `HEAD~1`）との差分を Diffview で開く
- `<leader>gC`: Diffview を閉じる
- `<leader>gT`: Diffview のファイルパネルを切り替え
- `<leader>gF`: 現在ファイルの履歴を表示
- `<leader>gH`: リポジトリのファイル履歴を表示
- `<leader>gs`: fugitive の Git status を開く
- `<leader>gv`: 現在ファイルの diff を垂直分割で開く
- `<leader>gx`: 現在ファイルの diff を水平分割で開く

# 設定構成

- プラグインマネージャ: `lazy.nvim`（`init.lua`）
- エディタ全体設定 & 診断表示: `lua/config/config.lua`
- 環境変数ファイル読み込み: `lua/config/env.lua`
- LSP コア（Mason + ネイティブ LSP + LspAttach マッピング）: `lua/plugins/nvim-lsp.lua`
- 補完（blink.cmp）セットアップ: `lua/plugins/cmp.lua`
- Tree-sitter parser 管理: `lua/plugins/nvim-treesitter.lua`
- ネイティブ Tree-sitter 起動: `lua/config/treesitter.lua`
- Git diff/review 補助: `lua/plugins/git-diff.lua`
- 言語サーバー定義: `lua/lsp/servers/*.lua`

## LSP Behavior
- サーバーは Mason でインストールし、起動は Neovim ネイティブ API（`vim.lsp.config` / `vim.lsp.enable`）で実施
- `lua/lsp/servers/<server>.lua` に定義があり、かつ Mason にインストール済みのサーバーだけを有効化
- バッファローカルのキーマップと `omnifunc` は `LspAttach` で付与
- LSP キーマップは attach したサーバーが対応 capability を持つ場合だけ作成
- Inlay Hints は対応サーバーではデフォルト有効、`<leader>li` で切替
- 診断 UI は `lua/config/config.lua` で一括設定

## Per-language LSP Definitions
`lua/lsp/servers/<server>.lua` に `cmd`, `filetypes`, `root_markers` を含む完全なサーバー設定を置きます。

用意済み:
- TypeScript (tsc): `lua/lsp/servers/tsc.lua`
- C/C++ (clangd): `lua/lsp/servers/clangd.lua`
- Bash (bashls): `lua/lsp/servers/bashls.lua`
- Lua (lua_ls): `lua/lsp/servers/lua_ls.lua`
- Go (gopls): `lua/lsp/servers/gopls.lua`

## 補完（blink.cmp）
- 設定は `lua/plugins/cmp.lua` に分離されています（LSP プラグインから独立）
- スニペットは blink.cmp の組み込み snippet source と `friendly-snippets` を使用
- 有効なソース: `lsp`, `path`, `snippets`, `buffer`
- 補完メニューの選択行とドキュメントフロートは見やすいように明示的に配色・表示設定
- cmdline mode でも blink.cmp を使い、最初に `<Tab>` を押さなくても候補メニューを自動表示

## Tree-sitter
- Parser のインストール管理は `neovim-treesitter/nvim-treesitter` と `treesitter-parser-registry` を使用
- 実際のハイライトや fold は Neovim ネイティブの `vim.treesitter.*` API で起動
- Parser は旧 nvim-treesitter の一括 module 設定ではなく、必要な言語を個別に導入する前提
- Plugin install 時に `:TSUpdate` は自動実行せず、parser 更新は必要なときだけ明示的に行う

## LSP テストファイル
- `test/ts/*.ts` と `test/cpp/*.{hpp,cpp}` は hover、定義、型定義、分割ジャンプ、参照、補完を確認するための snake_case サンプルです

## Git Diff ツール
- `gitsigns.nvim` はインライン sign、blame、現在ファイルの hunk/diff 確認を担当
- `diffview.nvim` はファイルパネル付きの左右 diff で作業ツリー、ブランチ差分、履歴確認を担当
- `vim-fugitive` は Git status と現在ファイルの split diff を担当

## 追加ユーティリティ

- 環境変数の上書き・追加:
  - 設定ディレクトリ直下の `.env` は起動時に自動読み込みされ、この Neovim 設定用の環境変数を上書き・追加できます
  - `.env.example` はローカル用変数のテンプレートです。必要に応じて `.env` にコピーして使います
  - `:EnvLoad`: Neovim を起動したディレクトリから上方向に `.env` を探し、手動で読み込みます
  - `:EnvLoad path/to/file.env`: 指定した env ファイルを手動で読み込みます
  - 実装: `lua/config/env.lua`
- 診断とコード行のヤンク:
  - `<leader>yd`: カーソル行 + 最初の診断メッセージをヤンク
  - `<leader>yad`: ファイル全体をヤンクし、その後に診断のある行＋メッセージを列挙してヤンク
  - `<leader>ys`（ビジュアル）: 選択ブロック全体を貼り付け、続けて選択範囲の診断一覧をヤンク
  - 実装: `lua/config/yank.lua`
- 診断、コメント、単語、選択範囲の翻訳（`GEMINI_API_KEY` と `GEMINI_MODEL` が必要）:
  - `<leader>td`（ノーマル）: 診断
  - `<leader>tc`（ノーマル）: 現在行のコメント
  - `<leader>tw`（ノーマル）: カーソル下の単語
  - `<leader>tt`（ノーマル）: 診断／コメント／単語を文脈で選択
  - `<leader>tt` / `<leader>td`（ビジュアル）: 選択範囲
  - `<leader>tr`（ビジュアル）: 翻訳して置換
  - 実装: `lua/config/ai/translate.lua`
- `:messages` の表示を分割で開く:
  - `<leader>ms`
  - 実装: `lua/config/message.lua`
- シェルコマンドの出力を現在行の下へ挿入:
  - `<leader>si`: コマンドを入力して出力を挿入
  - `:ShellInsert git status`
  - 実装: `lua/config/shell_insert.lua`

## 標準機能での代替

- `:read !cmd`: 現在行の下にコマンド出力を挿入
- `:%!cmd`: バッファ全体をコマンド出力で置換
- `:'<,'>!cmd`: 選択範囲をコマンドでフィルタ
- 例: `:read !ls`, `:%!sort`, `:'<,'>!jq .`

## 備考

- `.env` と `.env.*` は追跡しません。`.env.example` はテンプレートとして追跡します
- `lazy-lock.json` は追跡しません（.gitignore）。プラグインバージョンを固定したい場合は、各自で `.gitignore` から除外してください
