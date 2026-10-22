return {
  enabled = false,
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.python3_host_prog = vim.fn.system("which python3")
      vim.g.molten_output_win_max_height = 20
      -- Jupyter Notebook recommendations
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      -- Command                | Map
      -- -----------------------|-----
      -- MoltenInfo             |
      -- MoltenInit             | <localleader>mi
      -- MoltenDeinit           |
      -- MoltenGoto             |
      -- MoltenNext             |
      -- MoltenPrev             |
      -- MoltenEvaluateLine     | <localleader>rl
      -- MoltenEvaluateVisual   | <localleader>r
      -- MoltenEvaluateOperator | <localleader>me
      -- MoltenEvaluateArgument |
      -- MoltenReevaluateCell   | <localleader>rr
      -- MoltenDelete           | <localleader>md
      -- MoltenShowOutput       |
      -- MoltenHideOutput       | <localleader>oh
      -- MoltenEnterOutput      | <localleader>os
      -- MoltenInterrupt        |
      -- MoltenOpenInBrowser    | <localleader>mx
      -- MoltenImagePopup       |
      -- MoltenRestart          |
      -- MoltenSave             |
      -- MoltenLoad             |
      -- MoltenExportOutput     |
      -- MoltenImportOutput     |
      -- MoltenYankOutput       |
      vim.keymap.set(
        "n",
        "<localleader>me",
        ":MoltenEvaluateOperator<CR>",
        { desc = "evaluate operator", silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>os",
        ":noautocmd MoltenEnterOutput<CR>",
        { desc = "open output window", silent = true }
      )

      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
      vim.keymap.set(
        "v",
        "<localleader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { desc = "execute visual selection", silent = true }
      )
      vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

      -- if you work with html outputs:
      vim.keymap.set(
        "n",
        "<localleader>mx",
        ":MoltenOpenInBrowser<CR>",
        { desc = "open output in browser", silent = true }
      )

      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
    end,
  },
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "kitty", -- Compare: ueberzug
      processor = "magick_cli",
      max_width = 100, -- tweak to preference
      max_height = 12, -- ^
      max_height_window_percentage = math.huge, -- this is necessary for a good experience
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  -- {
  --   "willothy/wezterm.nvim",
  --   config = true,
  -- },
}
