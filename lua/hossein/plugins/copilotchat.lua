return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      -- { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "zbirenbaum/copilot.lua" },                   -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
      sticky = {
        '#glob:**'
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
