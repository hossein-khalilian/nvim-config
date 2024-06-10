return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({})
    vim.api.nvim_set_keymap("n", "<A-,>", "<Cmd>bp<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<A-.>", "<Cmd>bn<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<A-c>", "<Cmd>bd<CR>", { noremap = true, silent = true })
  end,
}
