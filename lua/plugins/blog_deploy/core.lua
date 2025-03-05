-- lua/plugins/blog_deploy/deploy.lua
local M = {}

function M.deploy_to_blog()
  -- 기존 deploy_to_blog 함수의 내용을 여기에 복사합니다
  -- 예:
  if not vim.g.blog_config then
    vim.notify("❌ opts가 설정되지 않았습니다!", vim.log.levels.ERROR)
    return
  end

  local blog_config = vim.g.blog_config or {}
  local blog_path = blog_config.path and vim.fn.expand(blog_config.path) or vim.fn.expand("~/my-blog")
  local branch = blog_config.branch or "blog"
  local vault_path = blog_config.vault_path and vim.fn.expand(blog_config.vault_path) or vim.fn.expand("~/vaults/notes")

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
  notify.dismiss({
    title = notify_title,
    pending = true,
    silent = true,
  }) -- 블로그 배포 제목을 가진 알림만 제거

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

  if timer ~= nil then
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
  end

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
      if timer ~= nil then
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
            notify("📄 실행 로그:\n" .. table.concat(stdout_data, "\n"):sub(1, 1000), vim.log.levels.DEBUG, {
              title = "배포 로그",
              timeout = 5000,
            })
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
            notify("🚨 에러 로그:\n" .. table.concat(stderr_data, "\n"):sub(1, 1000), vim.log.levels.ERROR, {
              title = "에러 상세",
              timeout = 10000,
            })
          end, 1000)
        end

        -- 출력 로그 (디버깅용)
        if #stdout_data > 0 then
          vim.defer_fn(function()
            notify("📄 출력 로그:\n" .. table.concat(stdout_data, "\n"):sub(1, 1000), vim.log.levels.DEBUG, {
              title = "실행 로그",
              timeout = 5000,
            })
          end, 2000)
        end
      end
    end,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

return M
