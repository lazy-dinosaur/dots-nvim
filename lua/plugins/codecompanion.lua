return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({

      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      -- 여기에 필요한 설정 옵션을 추가하세요
      -- 예: 자동 완성, 코드 포맷팅, 키맵핑 등
      auto_complete = true,
      format_on_save = true,
    })
  end,
}
