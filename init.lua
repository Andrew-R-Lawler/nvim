require("andrew")
print("hello")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
  {'ThePrimeagen/harpoon'},
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  {'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }},
  {'mbbill/undotree'},
  {'tpope/vim-fugitive'},
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
  { "rose-pine/neovim", name = "rose-pine" },
  {"williamboman/mason.nvim", version = "1.11.0"},
  {"williamboman/mason-lspconfig.nvim", version = "1.32.0"},
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                elixir = { "mix" }
            }
        })
    end
  },
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'alvan/vim-closetag'},
  {'hrsh7th/nvim-cmp'},
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
},
  {'mlaursen/vim-react-snippets'},
  },
  checker = { enabled = true },
})

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {'lua_ls', 'rust_analyzer', 'gopls', 'eslint' }, 
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  }
})
require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
    },
  },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require'lspconfig'.emmet_ls.setup({
    -- on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue", "tsx" },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    }
})
-- Minimal autocomplete configuration

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
})

-- nvim-surround configuration


vim.cmd('colorscheme rose-pine')
