return {
  -- Плагины для автодополнения
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require "configs.cmp"
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    after = "nvim-cmp",
  },
  {
    "hrsh7th/cmp-buffer",
    after = "nvim-cmp",
  },
  {
    "hrsh7th/cmp-path",
    after = "nvim-cmp",
  },
  {
    "hrsh7th/cmp-cmdline",
    after = "nvim-cmp",
  },
  {
    "hrsh7th/cmp-vsnip",
    after = "nvim-cmp",
  },
  {
    "hrsh7th/vim-vsnip",
    after = "nvim-cmp",
  },

  -- Плагины для LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua-language-server", "pyright", "tsserver", "html", "cssls", "clangd", "gopls", "prismals" }
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",  -- Добавление null-ls плагина
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.black,
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },

  -- Другие плагины...
}

