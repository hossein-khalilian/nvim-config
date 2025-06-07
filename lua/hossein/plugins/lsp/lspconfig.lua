return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local on_attach = function(_, bufnr)
      local keymap = vim.keymap
      local opts = { buffer = bufnr, noremap = true, silent = true }

      -- keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      -- keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      keymap.set("n", "gr", vim.lsp.buf.references, opts)
      keymap.set("n", "K", vim.lsp.buf.hover, opts)
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end

    -- configure gopls (Go)
    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          gofumpt = false,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })

    -- configure pyright (Python)
    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
