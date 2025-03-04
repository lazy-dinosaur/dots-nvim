-- ~/.config/nvim/lua/plugins/lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- markdown 파일에 대해서만 lint 실행
      filetypes = {
        markdown = { "markdownlint" },
      },
      -- 파일을 열거나 저장할 때만 lint 실행
      events = { "BufWritePost", "BufReadPost" },
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", "/home/lazydino/.config/nvim/markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
}
