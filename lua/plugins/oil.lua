return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["s"] = {
        "actions.select_vsplit",
        desc = "Open in vertical split",
      },
      ["S"] = {
        "actions.select_split",
        desc = "Open in horizontal split",
      },
      ["<C-t>"] = {
        "actions.select_tab",
        desc = "Open in new tab",
      },
      ["<C-p>"] = {
        "actions.preview",
        desc = "Open preview",
      },
      ["<C-c>"] = {
        "actions.close",
        desc = "Close oil",
      },
      ["<C-r>"] = {
        "actions.refresh",
        desc = "Refresh oil",
      },
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = {
        "actions.tcd",
        desc = "CD in tab",
      },
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
      ["<leader>P"] = function()
        local oil = require("oil")
        local filename = oil.get_cursor_entry().name
        local dir = oil.get_current_dir()
        oil.close()

        local img_clip = require("img-clip")
        img_clip.paste_image({}, dir .. filename)
      end,
    },
    use_default_keymaps = false,
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    view_options = {
      show_hidden = false,
    },
  },
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
