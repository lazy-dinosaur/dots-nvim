-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  command = "setlocal nospell",
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "oil",
--   callback = function()
--     vim.cmd("CodeiumDisable")
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "aider",
--   callback = function()
--     vim.cmd("CodeiumDisable")
--   end,
-- })
--
-- -- Re-enable Codeium when leaving oil buffer
-- vim.api.nvim_create_autocmd("BufLeave", {
--   pattern = "*",
--   callback = function(args)
--     if vim.bo[args.buf].filetype == "oil" then
--       vim.cmd("CodeiumEnable")
--     end
--   end,
-- })
--
-- -- Disable Codeium for aider buffers
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*",
--   callback = function(args)
--     if vim.bo[args.buf].filetype == "aider" then
--       vim.cmd("CodeiumDisable")
--     end
--   end,
-- })
--
-- -- Re-enable Codeium when leaving aider buffer
-- vim.api.nvim_create_autocmd("BufLeave", {
--   pattern = "*",
--   callback = function(args)
--     if vim.bo[args.buf].filetype == "aider" then
--       vim.cmd("CodeiumEnable")
--     end
--   end,
-- })
