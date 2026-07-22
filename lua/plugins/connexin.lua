return {
  {
    "recelsus/connexin.nvim",
    lazy = false,
    config = function()
      local connexin = require("connexin.init")

      connexin.setup({
        width = 0.8,
        height = 0.8,
        border = "rounded",
        indicators = {
          enabled = true,
          symbol = "󰈔",
          position = "eol",
          highlight = "ConnexinPathIndicator",
          max_lines = 5000,
          debounce_ms = 150,
        },
      })

      vim.keymap.set("n", "<leader>fp", function()
        connexin.open()
      end, {
        noremap = true,
        silent = true,
        desc = "[Connexin] Preview file under cursor",
      })
    end,
  },
}
