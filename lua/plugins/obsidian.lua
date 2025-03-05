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

      local function deploy_to_blog()
        if not vim.g.blog_config then
          vim.notify("❌ opts가 설정되지 않았습니다!", vim.log.levels.ERROR)
          return
        end

        local blog_config = vim.g.blog_config or {}
        local blog_path = blog_config.path and vim.fn.expand(blog_config.path) or vim.fn.expand("~/Development/my-blog")
        local branch = blog_config.branch or "blog"
        local vault_path = blog_config.vault_path and vim.fn.expand(blog_config.vault_path)
          or vim.fn.expand("~/vaults/notes")

        -- 디버깅용 출력
        print("📌 blog_path:", blog_path)
        print("📌 branch:", branch)
        print("📌 vault_path:", vault_path)

        -- 명령어에 동적 값 적용
        local cmd = string.format(
          "cd %s && git checkout %s && bun run deploy && git checkout -",
          vim.fn.shellescape(blog_path),
          vim.fn.shellescape(branch)
        )

        -- -- 디버깅용 로그
        -- vim.notify("📋 실행 명령어: " .. cmd, vim.log.levels.DEBUG)

        -- 로딩 애니메이션을 위한 변수
        -- 더 부드러운 애니메이션을 위한 프레임 증가
        local spinner_frames = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" }
        local current_frame = 1
        local timer
        local notify_title = "블로그 배포"

        -- 알림 모듈 직접 사용
        local notify = require("notify")

        -- 데이터 수집용 변수
        local stdout_data = {}
        local stderr_data = {}

        -- 기존 알림 모두 제거 (배포 관련 알림만 제거하려면 filter 옵션 추가)
        notify.dismiss({ title = notify_title }) -- 블로그 배포 제목을 가진 알림만 제거

        -- 알림 ID 저장용 변수
        local notification_id

        -- 초기 알림 생성
        notification_id = notify("블로그 배포 준비 중...", vim.log.levels.INFO, {
          title = notify_title,
          icon = "🚀",
          timeout = false,
          hide_from_history = false,
        })

        -- 로딩 애니메이션 시작 - 타이머 간격을 150ms로 줄여 더 부드럽게
        timer = vim.loop.new_timer()
        timer:start(
          100,
          50,
          vim.schedule_wrap(function()
            current_frame = (current_frame % #spinner_frames) + 1
            notification_id = notify("배포 진행 중... " .. spinner_frames[current_frame], vim.log.levels.INFO, {
              title = notify_title,
              icon = "🔄",
              timeout = false,
              replace = notification_id, -- 이전 알림 ID로 대체
            })
          end)
        )

        -- 작업 실행
        vim.fn.jobstart(cmd, {
          on_stdout = function(_, data)
            if data and #data > 0 then
              for _, line in ipairs(data) do
                if line and line ~= "" then
                  table.insert(stdout_data, line)
                end
              end
            end
          end,
          on_stderr = function(_, data)
            if data and #data > 0 then
              for _, line in ipairs(data) do
                if line and line ~= "" then
                  table.insert(stderr_data, line)
                end
              end
            end
          end,
          on_exit = function(_, code)
            -- 타이머 정리
            if timer then
              timer:stop()
              timer:close()
            end

            if code == 0 then
              -- 성공 알림
              notify("블로그 배포가 완료되었습니다!", vim.log.levels.INFO, {
                title = notify_title,
                icon = "✅",
                timeout = 3000,
                replace = notification_id, -- 이전 알림 ID로 대체
              })

              -- 성공 로그 (필요시)
              if #stdout_data > 0 then
                vim.defer_fn(function()
                  notify(
                    "📄 실행 로그:\n" .. table.concat(stdout_data, "\n"):sub(1, 1000),
                    vim.log.levels.DEBUG,
                    {
                      title = "배포 로그",
                      timeout = 5000,
                    }
                  )
                end, 1000)
              end
            else
              -- 실패 알림
              notify("블로그 배포에 실패했습니다! (코드: " .. code .. ")", vim.log.levels.ERROR, {
                title = notify_title,
                icon = "❌",
                timeout = 7000,
                replace = notification_id, -- 이전 알림 ID로 대체
              })

              -- 에러 로그
              if #stderr_data > 0 then
                vim.defer_fn(function()
                  notify(
                    "🚨 에러 로그:\n" .. table.concat(stderr_data, "\n"):sub(1, 1000),
                    vim.log.levels.ERROR,
                    {
                      title = "에러 상세",
                      timeout = 10000,
                    }
                  )
                end, 1000)
              end

              -- 출력 로그 (디버깅용)
              if #stdout_data > 0 then
                vim.defer_fn(function()
                  notify(
                    "📄 출력 로그:\n" .. table.concat(stdout_data, "\n"):sub(1, 1000),
                    vim.log.levels.DEBUG,
                    {
                      title = "실행 로그",
                      timeout = 5000,
                    }
                  )
                end, 2000)
              end
            end
          end,
          stdout_buffered = false,
          stderr_buffered = false,
        })
      end
      -- 키맵 설정
      map("n", "<localleader>oP", deploy_to_blog, map_opts)
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
      "rcarriga/nvim-notify",
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
        ["<A-CR>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
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
      wiki_link_func = "use_alias_only",
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,
      preferred_link_style = "wiki",
      disable_frontmatter = false,
      note_frontmatter_func = function(note)
        local out = {
          id = note.id,
          tags = note.tags,
          publish = "",
          series = "",
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
        pre_write_note = function(client, note)
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local content = table.concat(lines, "\n")
          local first_heading = content:match("#%s*(.-)\n")
          if first_heading and #first_heading > 0 then
            first_heading = first_heading:gsub('[/\\:*?"<>|]', "_"):gsub("^%s*(.-)%s*$", "%1")
            if #first_heading > 0 then
              local full_path = vim.fn.expand("%:p")
              local current_dir = vim.fn.fnamemodify(full_path, ":h")
              local current_filename = vim.fn.fnamemodify(full_path, ":t")
              local new_filename = first_heading .. ".md"
              local new_path = current_dir .. "/" .. new_filename
              if current_filename ~= new_filename then
                if vim.fn.filereadable(new_path) == 0 then
                  vim.cmd("silent! write")
                  local old_filename_no_ext = current_filename:gsub("%.md$", "")
                  local new_filename_no_ext = new_filename:gsub("%.md$", "")
                  local ok, err = pcall(function()
                    vim.cmd("silent! saveas! " .. vim.fn.fnameescape(new_path))
                    vim.cmd("bdelete! " .. vim.fn.fnameescape(full_path))
                    vim.cmd("silent! !rm " .. vim.fn.fnameescape(full_path))

                    local function get_workspace_root()
                      local full_path = vim.fn.expand("%:p")
                      local current_dir = vim.fn.fnamemodify(full_path, ":h")

                      -- Git 루트 찾기
                      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
                      if vim.fn.isdirectory(git_root) == 1 then
                        return git_root
                      end

                      -- `.obsidian` 폴더가 있으면 그걸 기준으로 루트 찾기
                      local obsidian_root = vim.fn.finddir(".obsidian", current_dir .. ";")
                      if obsidian_root and #obsidian_root > 0 then
                        return vim.fn.fnamemodify(obsidian_root, ":h")
                      end

                      -- 기본적으로 현재 파일이 있는 최상위 디렉터리 사용
                      return current_dir
                    end

                    local vault_path = get_workspace_root()
                    local Path = require("plenary.path")
                    local scan = require("plenary.scandir")

                    -- 볼트 내 모든 마크다운 파일 찾기
                    local function find_all_markdown_files(dir)
                      return scan.scan_dir(dir, { search_pattern = "%.md$", hidden = false, depth = 10 })
                    end

                    -- 파일 내용에서 백링크 업데이트
                    local function update_links_in_file(file_path, old_name, new_name)
                      local path = Path:new(file_path)
                      if not path:exists() then
                        return
                      end

                      local content = path:read()
                      if not content then
                        return
                      end

                      local updated = false

                      -- 1. 별칭 없는 위키 링크 처리
                      local wiki_pattern_simple = "%[%[%s*" .. vim.pesc(old_name) .. "%s*%]%]"
                      local wiki_replace_simple = "[[" .. new_name .. "]]"
                      if content:match(wiki_pattern_simple) then
                        content = content:gsub(wiki_pattern_simple, wiki_replace_simple)
                        updated = true
                      end

                      -- 2. 별칭 있는 위키 링크 처리
                      local wiki_pattern_alias = "%[%[%s*" .. vim.pesc(old_name) .. "%s*|%s*(.-)%s*%]%]"
                      local wiki_replace_alias = "[[" .. new_name .. "|%1]]"
                      if content:match(wiki_pattern_alias) then
                        content = content:gsub(wiki_pattern_alias, wiki_replace_alias)
                        updated = true
                      end

                      -- 마크다운 링크 형식 [텍스트](old_name.md) -> [텍스트](new_name.md) 업데이트
                      local md_pattern = "(%[.-%])%(" .. vim.pesc(old_name) .. "%.md%)"
                      local md_replace = "%1(" .. new_name .. ".md)"
                      if content:match(md_pattern) then
                        content = content:gsub(md_pattern, md_replace)
                        updated = true
                      end

                      -- 파일이 변경된 경우에만 저장
                      if updated then
                        path:write(content, "w")
                        print("✓ 백링크 업데이트 완료: " .. file_path)
                      end
                    end

                    -- 모든 마크다운 파일에서 백링크 업데이트 수행
                    local all_md_files = find_all_markdown_files(vault_path)
                    for _, file_path in ipairs(all_md_files) do
                      update_links_in_file(file_path, old_filename_no_ext, new_filename_no_ext)
                    end

                    -- 노트 경로 업데이트
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
