local lspconfig = require "lspconfig"
local null_ls = require "null-ls"
local configs = require "nvchad.configs.lspconfig"

local on_attach = configs.on_attach
local capabilities = configs.capabilities

-- Общая функция для настройки LSP серверов
local function setup_servers(servers)
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end

-- Список серверов для настройки
local servers = { "html", "cssls", "tsserver", "clangd", "gopls", "gradle_ls", "prismals", "pyright" }
setup_servers(servers)

-- Дополнительные настройки для pyright
lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Настройка null-ls для использования black
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.black,
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
    on_attach(client, bufnr)
  end,
}

-- Специальная команда для организации импортов в TypeScript
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

-- Добавление команды OrganizeImports для tsserver
lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", organize_imports, {})
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

