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

-- CodeCompanion 키맵
-- Normal 및 Visual 모드 공통
-- keymap.set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
-- keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Chat" })

-- Visual 모드 전용
-- keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to Chat" })

-- -- Normal 모드 전용
-- keymap.set("n", "<leader>ae", "<cmd>CodeCompanionChat Explain<cr>", { desc = "Explain Code" })
-- keymap.set("n", "<leader>ar", "<cmd>CodeCompanionChat Review<cr>", { desc = "Review Code" })
-- keymap.set("n", "<leader>af", "<cmd>CodeCompanionChat Fix<cr>", { desc = "Fix Code" })
-- keymap.set("n", "<leader>ad", "<cmd>CodeCompanionChat Document<cr>", { desc = "Document Code" })

-- Command abbreviation
keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Enter Normal mode from Terminal mode" })
-- vim.cmd([[cab cc CodeCompanion]])
