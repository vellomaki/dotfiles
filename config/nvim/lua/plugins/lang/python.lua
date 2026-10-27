return {
  --- Optionals
  { "nvim-neotest/neotest" }, -- Testing
  { "mfussenegger/nvim-dap" }, -- Debugging
  { "hrsh7th/nvim-cmp" }, -- Completions
  -- { "jay-babu/mason-nvim-dap.nvim" }, -- Bridge mason.nvim and nvim-dap
  { "dccsillag/magma-nvim" }, -- Jupyter notebooks

  --- Ensure Treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python" } },
  },
}
