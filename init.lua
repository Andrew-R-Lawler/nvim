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
  {'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }},
  {'mbbill/undotree'},
  {'tpope/vim-fugitive'},
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
  { "rose-pine/neovim", name = "rose-pine" },
  {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
  },
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
    -- add your plugins here
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {'lua_ls', 'rust_analyzer', 'gopls'},
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

vim.cmd('colorscheme rose-pine')
