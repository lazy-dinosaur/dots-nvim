return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>fP",
      function()
        Snacks.picker.files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
    {
      "\\f",
      function()
        Snacks.picker.files({
          hidden = true,
        })
      end,
      desc = "Lists files in your current working directory, respects .gitignore",
    },
    {
      "\\r",
      function()
        Snacks.picker.grep({
          live = true,
        })
      end,
      desc = "Search for a string in your current working directory and get results live as you type",
    },
    {
      "\\\\",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Lists open buffers",
    },
    {
      "\\h",
      function()
        Snacks.picker.help()
      end,
      desc = "Lists available help tags",
    },
    {
      "\\;",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume the previous picker",
    },
    {
      "\\e",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Lists Diagnostics for all open buffers",
    },
    {
      "\\s",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Lists Function names, variables, from LSP",
    },
  },
  opts = {
    picker = {
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.50,
        border = "rounded",
        preview = {
          horizontal = "right:50%",
          layout = "horizontal",
          scrollbar = false,
        },
      },
      keymap = {
        builtin = {
          ["<C-u>"] = "preview-page-up",
          ["<C-d>"] = "preview-page-down",
          ["<PageUp>"] = "preview-page-up",
          ["<PageDown>"] = "preview-page-down",
        },
      },
      fzf_opts = {
        ["--layout"] = "reverse",
      },
    },
  },
}
