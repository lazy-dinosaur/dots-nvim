return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      show_end_of_buffer = false,
      transparent_background = true,
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 1.15, -- percentage of the shade to apply to the inactive window
      },
      -- color_overrides = {
      --   all = {
      --     -- text = "#ffffff",
      --   },
      --   mocha = {
      --     -- base = "#1e1e2e",
      --   },
      --   frappe = {},
      --   macchiato = {},
      --   latte = {},
      -- },
      default_integrations = true,
      integrations = {
        headlines = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        grug_far = true,
        harpoon = true,
        noice = true,
        which_key = true,
        symbols_outline = true,
        fzf = true,
        indent_blankline = {
          enabled = true,
          scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        markdown = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = false,
          },
        },
        nvim_surround = true,
        overseer = true,
        flash = true,
        render_markdown = true,
        mason = true,
        neotree = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
          end
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
