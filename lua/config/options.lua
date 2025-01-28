-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim multi-cursor keymaps
vim.g.VM_leader = "<leader>m"
vim.g.VM_mouse_mappings = 0

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- 파일 백업 관련 설정
vim.opt.swapfile = false -- 스왑 파일 비활성화
vim.opt.backup = false -- 백업 파일 비활성화
vim.opt.writebackup = false -- 쓰기 전 백업 비활성화

-- Undo 설정
vim.opt.undofile = true -- 영구적인 undo 히스토리 저장

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- undo 파일 저장 위치  mkdir -p ~/.vim/undodir
vim.opt.undolevels = 10000 -- undo 가능한 최대 변경사항 수

-- File watching and auto-reload optimizations
vim.opt.autoread = true -- 외부 변경 감지
vim.opt.autowrite = true -- 자동 저장
vim.opt.updatetime = 250 -- 더 빠른 업데이트 시간
