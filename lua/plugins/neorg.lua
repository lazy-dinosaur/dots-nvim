return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-neorg/neorg-telescope",
    },
    lazy = false,
    version = "*",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
              icons = {
                code_block = {
                  conceal = true,
                },
              },
            },
          },
          ["core.latex.renderer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/.notes",
                inbox = "~/.notes/inbox",
                journal = "~/.notes/journal",
                project = "~/.notes/project",
                area = "~/.notes/area",
                resource = "~/.notes/resource",
                archive = "~/.notes/archive",
              },
              default_workspace = "inbox",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.journal"] = {
            config = {
              workspace = "journal",
              journal_folder = "daily",
              strategy = "flat",
            },
          },
          ["core.summary"] = {},
          ["core.export"] = {},
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader = "\\",
            },
          },
          ["core.integrations.telescope"] = {
            config = {
              search_headers = {
                tele_strict_indexing = false,
              },
            },
          },
          ["core.qol.toc"] = {},
          ["core.qol.todo_items"] = {},
          ["core.looking-glass"] = {},
          ["core.esupports.metagen"] = { config = { type = "auto" } },
          ["core.integrations.treesitter"] = {},
          ["core.ui.calendar"] = {},
        },
      })

      -- 새 노트 생성
      local function create_note_in_split(split_cmd)
        return function()
          -- 파일 이름 입력 받기
          local filename = vim.fn.input("Enter file name: ")
          -- 입력이 취소되거나 빈 문자열이면 종료
          if filename == "" then
            print("\nNote creation cancelled")
            return
          end

          -- 스플릿/탭 생성 후 새 노트 만들기
          if split_cmd then
            vim.cmd(split_cmd)
          end
          -- 현재 워크스페이스 경로 가져오기
          local neorg = require("neorg.core")
          local dirman = neorg.modules.get_module("core.dirman")
          local workspace = dirman.get_current_workspace()
          local workspace_path = dirman.get_workspace(workspace[1])

          -- 전체 파일 경로 생성
          local full_path = workspace_path .. "/" .. filename .. ".norg"
          -- 파일 생성 및 열기
          vim.cmd("edit " .. vim.fn.fnameescape(full_path))
        end
      end

      local new_note_keymaps = {
        ["\\nn"] = { create_note_in_split(nil), "New note in current buffer" },
        ["\\nv"] = { create_note_in_split("vsplit"), "New note in vertical split" },
        ["\\nh"] = { create_note_in_split("split"), "New note in horizontal split" },
        ["\\nt"] = { create_note_in_split("tabnew"), "New note in new tab" },
      }

      -- 워크스페이스 관련
      local workspace_keymaps = {
        ["\\ni"] = { "<cmd>Neorg workspace notes<cr>", "Switch to notes" },
        ["\\nwi"] = { "<cmd>Neorg workspace inbox<cr>", "Switch to inbox workspace" },
        ["\\nwj"] = { "<cmd>Neorg workspace journal<cr>", "Switch to journal workspace" },
        ["\\nwp"] = { "<cmd>Neorg workspace project<cr>", "Switch to project workspace" },
        ["\\nwa"] = { "<cmd>Neorg workspace area<cr>", "Switch to area workspace" },
        ["\\nwr"] = { "<cmd>Neorg workspace resource<cr>", "Switch to resource workspace" },
        ["\\nwA"] = { "<cmd>Neorg workspace archive<cr>", "Switch to archive workspace" },
        ["\\nww"] = { "<Plug>(neorg.telescope.switch_workspace)", "Switch workspace" },
      }

      -- 저널 관련
      local journal_keymaps = {
        ["\\njt"] = { "<cmd>Neorg journal today<cr>", "Open today's journal" },
        ["\\njm"] = { "<cmd>Neorg journal tomorrow<cr>", "Open tomorrow's journal" },
        ["\\njy"] = { "<cmd>Neorg journal yesterday<cr>", "Open yesterday's journal" },
        ["\\njc"] = { "<cmd>Neorg journal calendar<cr>", "Open calendar to select date" },
      }

      -- Telescope 통합 (파일/링크)
      local telescope_keymaps = {
        ["\\nff"] = { "<Plug>(neorg.telescope.find_norg_files)", "Find Neorg files" },
        ["\\nfh"] = { "<Plug>(neorg.telescope.search_headings)", "Search headers" },
        ["\\nfl"] = { "<Plug>(neorg.telescope.find_linkable)", "Find linkable items" },
        ["\\nfL"] = { "<Plug>(neorg.telescope.insert_link)", "Insert link" },
        ["\\nfF"] = { "<Plug>(neorg.telescope.insert_file_link)", "Insert file link" },
        ["\\nfb"] = { "<Plug>(neorg.telescope.backlinks.file_backlinks)", "Find file backlinks" },
        ["\\nfB"] = { "<Plug>(neorg.telescope.backlinks.header_backlinks)", "Find header backlinks" },
        ["\\nfw"] = { "<Plug>(neorg.telescope.switch_workspace)", "Switch workspace" },
      }

      -- -- Telescope 통합 (태스크)
      -- local task_keymaps = {
      --   ["\\ntp"] = { "<Plug>(neorg.telescope.find_project_tasks)", "Find project tasks" },
      --   ["\\nta"] = { "<Plug>(neorg.telescope.find_aof_tasks)", "Find area of focus tasks" },
      --   ["\\ntA"] = { "<Plug>(neorg.telescope.find_aof_project_tasks)", "Find area of focus project tasks" },
      -- }

      -- 기타
      local misc_keymaps = {
        ["\\nr"] = { "<cmd>Neorg return<cr>", "Return to previous location" },
      }

      -- 모든 키맵 적용
      local all_keymaps = vim.tbl_extend(
        "force",
        new_note_keymaps,
        workspace_keymaps,
        journal_keymaps,
        telescope_keymaps,
        -- task_keymaps,
        misc_keymaps
      )

      for k, v in pairs(all_keymaps) do
        vim.keymap.set("n", k, v[1], { desc = v[2], silent = true })
      end
    end,
  },
}
