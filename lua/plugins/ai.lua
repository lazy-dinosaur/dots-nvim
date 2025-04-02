return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        -- Required options
        port = 3000, -- Port for MCP Hub server
        config = vim.fn.expand("/home/lazydino/.config/Claude/claude_desktop_config.json"), -- Absolute path to config file

        -- Optional options
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = {
      "AiderTerminalToggle",
      "AiderHealth",
    },
    keys = {
      { "<leader>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
      { "<leader>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
      { "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
      { "<leader>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
      { "<leader>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
      { "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
      -- Example nvim-tree.lua integration if needed
      { "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
      { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
    },
    dependencies = {
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim",
      --- The below dependencies are optional
      "catppuccin/nvim",
      "nvim-tree/nvim-tree.lua",
    },
    opts = {
      aider_cmd = "aider",
      args = {
        "--no-auto-commits",
      },
      picker_cfg = {
        preset = "vscode",
      },
      win = {
        style = "nvim_aider",
        position = "right",
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "openrouter",
      vendors = {
        openrouter = {
          endpoint = "https://openrouter.ai/api/v1",
          model = "anthropic/claude-3.7-sonnet",
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          disable_tools = false,
        },
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("codecompanion").setup({
  --       opts = {
  --         language = "한국어",
  --       },
  --       adapters = {
  --         openrouter = function()
  --           return require("codecompanion.adapters").extend("openai_compatible", {
  --             env = {
  --               url = "https://openrouter.ai/api",
  --               api_key = "OPENROUTER_API_KEY",
  --               chat_url = "/v1/chat/completions",
  --             },
  --             schema = {
  --               model = {
  --                 default = "deepseek/deepseek-r1",
  --               },
  --             },
  --           })
  --         end,
  --       },
  --       strategies = {
  --         chat = {
  --           adapter = "openrouter",
  --           slash_commands = {
  --             ["file"] = {
  --               opts = { provider = "fzf_lua" },
  --             },
  --             ["buffer"] = {
  --               opts = { provider = "fzf_lua" },
  --             },
  --           },
  --           tools = {
  --             ["mcp"] = {
  --               -- calling it in a function would prevent mcphub from being loaded before it's needed
  --               callback = function()
  --                 return require("mcphub.extensions.codecompanion")
  --               end,
  --               description = "Call tools and resources from the MCP Servers",
  --               opts = {
  --                 requires_approval = false,
  --               },
  --             },
  --           },
  --         },
  --         inline = {
  --           adapter = "openrouter",
  --         },
  --       },
  --       auto_complete = true,
  --       format_on_save = true,
  --       display = {
  --         chat = {
  --           intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
  --           show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
  --           separator = "─", -- The separator between the different messages in the chat buffer
  --           show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
  --           show_settings = false, -- Show LLM settings at the top of the chat buffer?
  --           show_token_count = true, -- Show the token count for each response?
  --           start_in_insert_mode = false, -- Open the chat buffer in insert mode?
  --           window = {
  --             layout = "vertical", -- float|vertical|horizontal|buffer
  --             position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
  --             border = "single",
  --             height = 0.8,
  --             width = 0.3,
  --             relative = "editor",
  --             opts = {
  --               breakindent = true,
  --               cursorcolumn = false,
  --               cursorline = false,
  --               foldcolumn = "0",
  --               linebreak = true,
  --               list = false,
  --               numberwidth = 1,
  --               signcolumn = "no",
  --               spell = false,
  --               wrap = true,
  --             },
  --           },
  --         },
  --         action_palette = {
  --           width = 95,
  --           height = 10,
  --           prompt = "Prompt ", -- Prompt used for interactive LLM calls
  --           provider = "default", -- default|telescope|mini_pick
  --           opts = {
  --             show_default_actions = true, -- Show the default actions in the action palette?
  --             show_default_prompt_library = true, -- Show the default prompt library in the action palette?
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
}
