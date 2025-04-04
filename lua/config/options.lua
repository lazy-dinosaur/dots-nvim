-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim multi-cursor keymaps
vim.g.VM_leader = "<localleader>m"
vim.g.VM_mouse_mappings = 0

-- Memory management
vim.opt.maxmempattern = 2000 -- 패턴 매칭 메모리 제한
vim.opt.history = 100 -- 명령어 기록 제한
vim.opt.hidden = false -- 버퍼 숨김 비활성화로 메모리 관리

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- 파일 백업 관련 설정
vim.opt.swapfile = false -- 스왑 파일 비활성화
vim.opt.backup = false -- 백업 파일 비활성화
vim.opt.writebackup = false -- 쓰기 전 백업 비활성화

-- Undo 설정
vim.opt.undofile = true -- 영구적인 undo 히스토리 저장

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- undo 파일 저장 위치  mkdir -p ~/.vim/undodir
vim.opt.undolevels = 1000 -- undo 가능한 최대 변경사항 수

-- File watching and auto-reload optimizations
vim.opt.autoread = true -- 외부 변경 감지
vim.opt.autowrite = true -- 자동 저장
vim.opt.updatetime = 250 -- 더 빠른 업데이트 시간

-- Line break settings
vim.opt.linebreak = true -- 단어 단위 줄바꿈 활성화

-- 블로그 배포 관련 설정을 전역 변수로 저장
vim.g.blog_config = {
  path = "~/Development/my-blog", -- 블로그 저장소 경로
  branch = "blog", -- 배포용 브랜치
  vault_path = "~/vaults/notes", -- 옵시디언 볼트 경로
}
