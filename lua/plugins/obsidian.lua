return {
  {
    "oflisback/obsidian-bridge.nvim",
    opts = {
      obsidian_server_address = "http://localhost:27123",
      scroll_sync = true,
      warnings = true,
    },
    event = {
      "BufReadPre *.md",
      "BufNewFile *.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "HakonHarnes/img-clip.nvim",
    },
    config = function(_, opts)
      require("obsidian-bridge").setup(opts)

      -- localleader b로 시작하는 키맵 설정 (bridge)
      local map = vim.keymap.set
      local map_opts = { noremap = true, silent = true }

      -- 기본 기능
      map("n", "<localleader>bd", "<cmd>ObsidianBridgeDailyNote<CR>", map_opts) -- 데일리 노트
      map("n", "<localleader>bg", "<cmd>ObsidianBridgeOpenGraph<CR>", map_opts) -- 그래프 뷰
      map("n", "<localleader>bv", "<cmd>ObsidianBridgeOpenVaultMenu<CR>", map_opts) -- 볼트 선택
      map("n", "<localleader>bc", "<cmd>ObsidianBridgeTelescopeCommand<CR>", map_opts) -- 명령어 목록

      -- 플러그인 토글
      map("n", "<localleader>bt", "<cmd>ObsidianBridgeToggle<CR>", map_opts) -- 토글
      map("n", "<localleader>bo", "<cmd>ObsidianBridgeOn<CR>", map_opts) -- 활성화
      map("n", "<localleader>bx", "<cmd>ObsidianBridgeOff<CR>", map_opts) -- 비활성화
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- localleader o로 시작하는 키맵 설정
      local map = vim.keymap.set
      local map_opts = { noremap = true, silent = true }

      -- 노트 탐색/생성
      map("n", "<localleader>of", "<cmd>ObsidianQuickSwitch<CR>", map_opts) -- 노트 빠른 전환
      map("n", "<localleader>on", "<cmd>ObsidianNew<CR>", map_opts) -- 새 노트 생성
      map("n", "<localleader>od", "<cmd>ObsidianToday<CR>", map_opts) -- 오늘의 데일리 노트

      -- 검색
      map("n", "<localleader>os", "<cmd>ObsidianSearch<CR>", map_opts) -- 노트 검색
      map("n", "<localleader>ob", "<cmd>ObsidianBacklinks<CR>", map_opts) -- 백링크 검색

      -- 링크 관련
      map("n", "<localleader>ol", "<cmd>ObsidianLink<CR>", map_opts) -- 링크 생성
      map("n", "<localleader>oL", "<cmd>ObsidianLinkNew<CR>", map_opts) -- 새 노트로 링크
      map("v", "<localleader>ol", ":<C-u>ObsidianLink<CR>", map_opts) -- 선택 텍스트를 링크로

      -- 템플릿
      map("n", "<localleader>or", "<cmd>ObsidianTemplate<CR>", map_opts) -- 템플릿 삽입

      -- 태그
      map("n", "<localleader>ot", "<cmd>ObsidianTags<CR>", map_opts) -- 태그 검색

      -- 기타
      map("n", "<localleader>oo", "<cmd>ObsidianOpen<CR>", map_opts) -- Obsidian 앱에서 열기

      map("n", "<localleader>op", "<cmd>PasteImage<CR>", map_opts) -- 이미지 붙여넣기
    end,
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/vaults/notes",
        },
      },
      notes_subdir = "0.inbox",
      log_level = vim.log.levels.INFO,
      daily_notes = {
        folder = "0.inbox/0.daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily" },
        template = nil,
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- ["<cr>"] = {
        --   action = function()
        --     return require("obsidian").util.smart_action()
        --   end,
        --   opts = { buffer = true, expr = true },
        -- },
      },
      new_notes_location = "notes_subdir",
      note_id_func = function()
        local suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.title or "untitled")
        return path:with_suffix(".md")
      end,
      wiki_link_func = "prepend_note_path",
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "wiki",
      disable_frontmatter = false,
      note_frontmatter_func = function(note)
        local out = {
          id = note.id,
          -- aliases = note.aliases,
          tags = note.tags,
          createdAt = os.date("%Y-%m-%d %H:%M:%S"), -- 생성 시간 추가
          modifiedAt = os.date("%Y-%m-%d %H:%M:%S"), -- 생성 시간 추가
        }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      templates = {
        folder = "_templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
      follow_img_func = function(img)
        vim.fn.jobstart({ "qlmanage", "-p", img })
      end,
      use_advanced_uri = false,
      open_app_foreground = false,
      picker = {
        name = "fzf-lua",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
      sort_by = "modified",
      sort_reversed = true,
      search_max_lines = 1000,
      open_notes_in = "current",
      callbacks = {
        enter_note = function(client, note)
          -- 새 버퍼에서만 매핑 생성
          if vim.bo.filetype == "markdown" then
            vim.keymap.set("n", "<cr>", function()
              return require("obsidian").util.smart_action()
            end, { buffer = true, expr = true })
          end
        end,

        pre_write_note = function(client, note)
          -- 현재 버퍼에서 <cr> 매핑 제거
          vim.keymap.del("n", "<cr>", { buffer = true })
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local content = table.concat(lines, "\n")
          -- 첫 번째 헤딩 추출
          local first_heading = content:match("#%s*(.-)\n")

          if first_heading and #first_heading > 0 then
            -- 헤딩에서 파일명으로 사용할 수 없는 문자 제거
            first_heading = first_heading:gsub('[/\\:*?"<>|]', "_")
            first_heading = first_heading:gsub("^%s*(.-)%s*$", "%1") -- 앞뒤 공백 제거

            if #first_heading > 0 then
              print("파일명으로 변환된 헤딩:", first_heading)

              -- 현재 파일의 전체 경로 가져오기
              local full_path = vim.fn.expand("%:p")
              print("현재 파일 전체 경로:", full_path)

              -- 현재 폴더 경로 및 파일명 분리
              local current_dir = vim.fn.fnamemodify(full_path, ":h")
              local current_filename = vim.fn.fnamemodify(full_path, ":t")
              print("현재 폴더:", current_dir)
              print("현재 파일명:", current_filename)

              -- 새 파일 경로 생성 (같은 폴더에 새 파일명으로)
              local new_filename = first_heading .. ".md"
              local new_path = current_dir .. "/" .. new_filename
              print("새 파일 경로:", new_path)

              -- 현재 파일명과 새 파일명이 다른 경우에만 처리
              if current_filename ~= new_filename then
                -- 파일이 이미 존재하는지 확인
                if vim.fn.filereadable(new_path) == 0 then
                  -- 파일 저장 확인
                  vim.cmd("silent! write")

                  -- pcall로 오류 잡기
                  local ok, err = pcall(function()
                    -- 파일 이름 변경 (Vim 명령어 사용)
                    vim.cmd("silent! saveas! " .. vim.fn.fnameescape(new_path))

                    -- 현재 버퍼 강제로 닫기
                    vim.cmd("bdelete! " .. vim.fn.fnameescape(full_path))
                    vim.cmd("silent! !rm " .. vim.fn.fnameescape(full_path))

                    -- 노트 경로 업데이트 (Path 객체로 변환)
                    local Path = require("plenary.path")
                    note.path = Path:new(new_path)
                  end)

                  if ok then
                    print("✓ 파일 이름 변경 성공:", new_filename)
                  else
                    print("✗ 파일 이름 변경 실패:", tostring(err))
                  end
                else
                  print("✗ 같은 이름의 파일이 이미 존재함:", new_path)
                end
              else
                print("현재 파일명이 이미 헤딩과 동일함")
              end
            end
          else
            print("헤딩을 찾을 수 없음")
          end

          -- 메타데이터 업데이트
          local frontmatter = note.metadata or {}
          frontmatter.modifiedAt = os.date("%Y-%m-%d %H:%M:%S")
        end,
      },
      ui = {
        enable = true,
        update_debounce = 200,
        max_file_length = 5000,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
      attachments = {
        img_folder = "_assets/imgs",
        img_name_func = function()
          return string.format("%s-", os.time())
        end,
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
    },
  },
}
