return {
  --- Ensure Optionals
  -- { "mason-org/mason.nvim" },
  { "nvim-neotest/neotest" },

  --- Ensure Treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    -- TODO: can this be just a dictionary, not a functions?
    opts = { ensure_installed = { "rust" } },
  },
}
