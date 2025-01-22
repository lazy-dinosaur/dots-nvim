return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>fP",
      function()
        require("fzf-lua").files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
    {
      "\\f",
      function()
        require("fzf-lua").files({
          hidden = true,
        })
      end,
      desc = "Lists files in your current working directory, respects .gitignore",
    },
    {
      "\\r",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Search for a string in your current working directory and get results live as you type",
    },
    {
      "\\\\",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Lists open buffers",
    },
    {
      "\\t",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "Lists available help tags",
    },
    {
      "\\;",
      function()
        require("fzf-lua").resume()
      end,
      desc = "Resume the previous fzf-lua picker",
    },
    {
      "\\e",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "Lists Diagnostics for all open buffers",
    },
    {
      "\\s",
      function()
        require("fzf-lua").lsp_document_symbols()
      end,
      desc = "Lists Function names, variables, from LSP",
    },
  },
  opts = {
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
    file_browser = {
      dir_icon = "",
      mappings = {
        ["N"] = "create",
        ["h"] = "parent_dir",
      },
    },
  },
}
