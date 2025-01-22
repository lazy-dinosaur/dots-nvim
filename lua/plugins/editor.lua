return {
  {
    "monaqa/dial.nvim",
  -- stylua: ignore
  keys = (function()
    if vim.fn.exists("$TMUX") == 1 then
      -- tmux 환경일 때
      return {
        { "<A-+>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
        { "<A-->", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      }
    else
      -- tmux 환경이 아닐 때
      return {
        { "<A-KPlus>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
        { "<A-KMinus>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      }
    end
  end)(),
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
      })
    end,
  },
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        symbols = {
          icons = {},
          -- filter = vim.deepcopy(LazyVim.config.kind_filter),
          filter = nil,
          -- filter =
        },
        keymaps = {
          up_and_jump = "<up>",
          down_and_jump = "<down>",
        },
      }

      for kind, symbol in pairs(defaults.symbols.icons) do
        opts.symbols.icons[kind] = {
          icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
      end
      return opts
    end,
  },
}
