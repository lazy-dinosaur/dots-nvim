-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local keymap = vim.keymap
-- local opts = { noremap = false, silent = true }

keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- 현재 파일 경로 복사
keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  local home = vim.fn.expand("$HOME")
  path = path:gsub(home, "~")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy file path" })

-- 현재 파일의 상대 경로 복사
keymap.set("n", "<leader>fY", function()
  local path = vim.fn.expand("%")
  local home = vim.fn.expand("$HOME")
  path = path:gsub(home, "~")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy relative file path" })
