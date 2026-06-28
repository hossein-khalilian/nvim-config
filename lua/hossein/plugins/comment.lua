return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- use the modern ts_context_commentstring setup instead of the
    -- legacy auto-loaded module (avoids errors on Neovim 0.11+)
    vim.g.skip_ts_context_commentstring_module = true
    require("ts_context_commentstring").setup({ enable_autocmd = false })

    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })

    -- Neovim 0.11+ no longer errors from `vim.treesitter.get_parser` for
    -- buffers without a parser (e.g. `.env`, `text`); it returns nil. Comment
    -- .nvim's ft.calculate only guards the old throwing behaviour, so it then
    -- indexes a nil tree and fails with a swallowed "[Comment.nvim] nil".
    -- Wrap it to fall back to the buffer's commentstring when there's no parser.
    local cft = require("Comment.ft")
    local calculate = cft.calculate
    rawset(cft, "calculate", function(ctx)
      local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
      if not ok or not parser then
        return cft.get(vim.bo.filetype, ctx.ctype)
      end
      return calculate(ctx)
    end)
  end,
}
