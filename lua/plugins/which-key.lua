return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    config = function()
      local wk = require("which-key")

      wk.setup {
        triggers = {
         { "<leader>", mode = "nv" },
        },
        icons = {
          separator = "=>",
          group = "",
        }
      }

      wk.add({ "<leader>l", desc = "LSP", icon = "" })
      wk.add({ "<leader>f", desc = "Find", icon = "" })
      wk.add({ "<leader>g", desc = "Git", icon = "" })
      wk.add({ "<leader>h", desc = "Help", icon = "󰞋" })
      wk.add({ "<leader>t", desc = "Translate", icon = "" })
      wk.add({ "<leader>y", desc = "Yank", icon = "" })
      wk.add({ "<leader>c", desc = "Comment", icon = "󰚰" })
      wk.add({ "<leader>m", desc = "Msg", icon = "" })
      wk.add({ "<leader>s", desc = "Shell", icon = "" })
      wk.add({ "<leader>a", desc = "Athanor", icon = "󰪶" })

      -- Sub-entries to ensure visibility in which-key
      wk.add({ "<leader>ff", desc = "find: files", mode = "n" })
      wk.add({ "<leader>fg", desc = "find: grep", mode = "n" })
      wk.add({ "<leader>fb", desc = "find: buffers", mode = "n" })
      wk.add({ "<leader>fh", desc = "find: help", mode = "n" })
      wk.add({ "<leader>fk", desc = "find: keymaps", mode = "n" })

      wk.add({ "<leader>gb", desc = "git: blame toggle", mode = "n" })
      wk.add({ "<leader>gd", desc = "git: diff", mode = "n" })
      wk.add({ "<leader>gC", desc = "git: diff close", mode = "n" })
      wk.add({ "<leader>gD", desc = "git: diff view", mode = "n" })
      wk.add({ "<leader>gF", desc = "git: file history", mode = "n" })
      wk.add({ "<leader>gH", desc = "git: repo history", mode = "n" })
      wk.add({ "<leader>gM", desc = "git: diff default", mode = "n" })
      wk.add({ "<leader>gs", desc = "git: status", mode = "n" })
      wk.add({ "<leader>gT", desc = "git: diff files toggle", mode = "n" })
      wk.add({ "<leader>gv", desc = "git: file vsplit diff", mode = "n" })
      wk.add({ "<leader>gx", desc = "git: file split diff", mode = "n" })

      wk.add({ "<leader>yd", desc = "diag: yank line", mode = "n" })
      wk.add({ "<leader>yad", desc = "diag: yank all", mode = "n" })
      wk.add({ "<leader>ys", desc = "diag: yank sel", mode = "x" })
      wk.add({ "<leader>hj", desc = "help: ja", mode = "n" })
      wk.add({ "<leader>he", desc = "help: en", mode = "n" })

      wk.add({ "<leader>le", desc = "lsp: diag float", mode = "n" })
      wk.add({ "<leader>lp", desc = "lsp: type preview", mode = "n" })

      wk.add({ "<leader>cb", desc = "comment: box", mode = "n" })
      wk.add({ "<leader>cb", desc = "comment: box", mode = "v" })

      wk.add({ "<leader>tc", desc = "translate: comment", mode = "n" })
      wk.add({ "<leader>td", desc = "translate: diag", mode = "n" })
      wk.add({ "<leader>td", desc = "translate: selection", mode = "x" })
      wk.add({ "<leader>tt", desc = "translate: cursor", mode = "n" })
      wk.add({ "<leader>tt", desc = "translate: selection", mode = "x" })
      wk.add({ "<leader>tr", desc = "translate: replace", mode = "x" })
      wk.add({ "<leader>tw", desc = "translate: word", mode = "n" })
      wk.add({ "<leader>si", desc = "shell: insert output", mode = "n" })
    end
  }
}
