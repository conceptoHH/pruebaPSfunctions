vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number")
vim.g.mapleader= " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' } },
    {"nvim-treesitter/nvim-treesitter", branch = 'master', build= ":TSUpdate"},
    -- lspconfig
    {"mason-org/mason-lspconfig.nvim", opts = {},
        dependencies = { { "mason-org/mason.nvim", opts = {} },"neovim/nvim-lspconfig",}},
    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"L3MON4D3/LuaSnip",
        dependencies = { "saadparwaiz1/cmp_luasnip","rafamadriz/friendly-snippets" }},
    {"nvim-neo-tree/neo-tree.nvim",branch = "v3.x",
        dependencies = {"nvim-lua/plenary.nvim",    "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons"},  lazy = false, -- neo-tree will lazily load itself}
    },
    {"nyoom-engineering/oxocarbon.nvim"}
}

require("lazy").setup(plugins, opts)
require("catppuccin").setup()

-- neotree
vim.keymap.set('n', '<leader>o',':Neotree toggle left reveal_force_cwd<cr>')

-- telescope

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- treesitter
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"lua", "javascript", "c", "python", "go",},
  highlight = { enable = true },
  indent = { enable = true }
})

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Cargar la colección de snippets de 'friendly-snippets'
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  -- El motor de snippets es obligatorio para nvim-cmp
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  -- Atajos de teclado para la ventana emergente
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.complete(), -- Forzar apertura del menú
    ['<C-e>'] = cmp.mapping.abort(),        -- Cerrar el menú
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 'Enter' para autocompletar
  }),
  -- De dónde saca cmp las palabras sugeridas
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Palabras del servidor LSP (C, Go, TS, etc.)
    { name = 'luasnip' },  -- Snippets de código
  })
})

-- Obtenemos las capacidades generadas por nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lista de servidores a configurar (deben estar instalados vía :Mason)
local servers = { 'clangd', 'html', 'cssls', 'ts_ls', 'lua_ls', 'ty', 'rumdl','jdtls'}

-- Bucle para inyectar capacidades y habilitar cada servidor
for _, lsp in ipairs(servers) do
  vim.lsp.config[lsp] = {
    capabilities = capabilities,
  }
  -- Nueva API nativa para inicializar servidores
  vim.lsp.enable(lsp)
end

vim.opt.background = "dark"
vim.cmd.colorscheme "oxocarbon"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
