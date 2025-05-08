return {
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = "openrouter",
  --     openai = {
  --       endpoint = "https://api.openai.com/v1",
  --       model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
  --       timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
  --       temperature = 0,
  --       max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
  --       --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  --     },
  --     vendors = {
  --       openrouter = {
  --         __inherited_from = "openai",
  --         endpoint = "https://openrouter.ai/api/v1",
  --         api_key_name = "OPENROUTER_API_KEY",
  --         model = "google/gemini-2.5-pro-preview",
  --         disable_tools = {
  --           "list_files",
  --           "search_files",
  --           "read_file",
  --           "create_file",
  --           "rename_file",
  --           "delete_file",
  --           "create_dir",
  --           "rename_dir",
  --           "delete_dir",
  --           "bash",
  --         },
  --       },
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     extensions = {
  --       mcphub = {
  --         callback = "mcphub.extensions.codecompanion",
  --         opts = {
  --           show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
  --           make_vars = true, -- make chat #variables from MCP server resources
  --           make_slash_commands = true, -- make /slash_commands from MCP server prompts
  --         },
  --         config = {
  --           auto_approve = true,
  --         },
  --       },
  --     },
  --     strategies = {
  --       chat = {
  --         adapter = "openrouter",
  --       },
  --       inline = {
  --         adapter = "openrouter",
  --       },
  --     },
  --     adapters = {
  --       openrouter = function()
  --         return require("codecompanion.adapters").extend("openai_compatible", {
  --           env = {
  --             url = "https://openrouter.ai/api",
  --             api_key = "OPENROUTER_API_KEY",
  --             chat_url = "/v1/chat/completions",
  --           },
  --           schema = {
  --             model = {
  --               default = "google/gemini-2.5-pro-preview",
  --             },
  --           },
  --         })
  --       end,
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },
  -- {
  --   "ravitemer/mcphub.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  --   },
  --   -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
  --   build = "bun install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  --   config = function()
  --     require("mcphub").setup({
  --       extensions = {
  --         avante = {
  --           make_slash_commands = true, -- make /slash commands from MCP server prompts
  --         },
  --       },
  --       -- Required options
  --       port = 8880, -- Port for MCP Hub server
  --       config = vim.fn.expand("/home/lazydino/.config/Claude/claude_desktop_config.json"), -- Absolute path to config file
  --
  --       -- Optional options
  --       on_ready = function(hub)
  --         -- Called when hub is ready
  --       end,
  --       on_error = function(err)
  --         -- Called on errors
  --       end,
  --       log = {
  --         level = vim.log.levels.WARN,
  --         to_file = false,
  --         file_path = nil,
  --         prefix = "MCPHub",
  --       },
  --     })
  --   end,
  -- },
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
  -- Codeium 플러그인 설정 추가 (ai.lua에는 주석처리 해두고 coding.lua에서 관리)
  -- {
  --   "Exafunction/codeium.nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("codeium").setup({
  --       enable_chat = false,
  --       tools = {},
  --       wrapper = nil,
  --       enable_cmp_source = false,
  --       virtual_text = {
  --         enabled = false,
  --         default_filetype_enabled = false,
  --         manual = true,
  --       },
  --     })
  --   end,
  -- },
}
