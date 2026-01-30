return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install", -- or: "cd app && npm install"
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
