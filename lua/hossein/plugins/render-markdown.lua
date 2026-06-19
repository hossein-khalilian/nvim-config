return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- markdown & markdown_inline parsers
    "nvim-tree/nvim-web-devicons", -- icons in rendered output
  },
  opts = {},
  keys = {
    { "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", desc = "Markdown preview (toggle render)" },
  },
}
