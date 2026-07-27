return {
  {
    "recelsus/Athanor.nvim",
    lazy = false,
    opts = {
      view = {
        split = "horizontal",
        width = 40,
        follow_interval_ms = 500,
        detail = {
          ratio = 0.7,
          focus = false,
        },
      },
    },
    keys = {
      {
        "<leader>ao",
        "<cmd>AthanorOpen<CR>",
        desc = "athanor: open",
      },
      {
        "<leader>as",
        "<cmd>AthanorSearch<CR>",
        desc = "athanor: search",
      },
      {
        "<leader>af",
        "<cmd>AthanorSearchContent<CR>",
        desc = "athanor: search content",
      },
      {
        "<leader>ay",
        "<cmd>AthanorSaveYank<CR>",
        desc = "athanor: save yank",
      },
      {
        "<leader>av",
        ":AthanorSaveVisual<CR>",
        mode = "x",
        desc = "athanor: save selection",
      },
      {
        "<leader>am",
        "<cmd>AthanorMessages<CR>",
        desc = "athanor: save messages",
      },
      {
        "<leader>at",
        "<cmd>AthanorTerminal<CR>",
        desc = "athanor: save terminal",
      },
      {
        "<leader>ac",
        ":AthanorCommand ",
        desc = "athanor: run command",
      },
    },
  },
}
