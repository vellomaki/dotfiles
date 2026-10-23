{
  lib,
  pkgs,
}:
with pkgs.vimPlugins;
let
  # Some pkgs's names don't match the lazy.nvim name so we have to marry the two
  LuaSnip = {
    name = "LuaSnip";
    path = luasnip;
  };
  catppuccin = {
    name = "catppuccin";
    path = catppuccin-nvim;
  };
  luasnip-latex-snippets-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "luasnip-latex-snippets.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "iurimateus";
      repo = "luasnip-latex-snippets.nvim";
      rev = "84d37a68b5858bafe75573f8ea6898ba095fef45";
      hash = "sha256-X6Ea16z5sxjJpKcI3xCQkYOdlTKttntj4vNhQHqWQC8=";
    };
    dependencies = [
      luasnip
      vimtex
    ];
  };

  # NOTE: these are structures [required] ++ [optional]
  lazyVim.lang.markdown = [
    markdown-preview-nvim
    mason-nvim
    nvim-lspconfig
    render-markdown-nvim
  ]
  ++ [
    conform-nvim
    nvim-lint
  ];
  lazyVim.lang.nix = [
    nvim-lspconfig
    nvim-treesitter
  ]
  ++ [
    conform-nvim
    nvim-lint
  ];
  lazyVim.lang.python = [
    magma-nvim
    neotest-python
    nvim-dap-python
    nvim-lspconfig
    nvim-treesitter
    venv-selector-nvim
  ]
  ++ [
    neotest
    nvim-cmp
    nvim-dap
    mason-nvim-dap-nvim
  ];
  lazyVim.lang.rust = [
    crates-nvim
    nvim-lspconfig
    nvim-treesitter
    rustaceanvim
  ]
  ++ [
    mason-nvim
    neotest
  ];
  lazyVim.lang.tex = [
    nvim-treesitter
    vimtex
  ]
  ++ [ nvim-lspconfig ];
  lazyVim.lang.wgsl = [
    nvim-lspconfig
    nvim-treesitter
  ];
  lazyVim.plugins.coding = [
    lazydev-nvim
    mini-ai
    mini-pairs
    ts-comments-nvim
  ];
  lazyVim.plugins.colorscheme = [
    catppuccin
    tokyonight-nvim
  ]
  ++ [ bufferline-nvim ];
  lazyVim.plugins.editor = [
    flash-nvim
    gitsigns-nvim
    grug-far-nvim
    todo-comments-nvim
    trouble-nvim
    which-key-nvim
  ];
  lazyvim.plugins.extras.lang =
    map
      (l: {
        name = "lazyvim.plugins.extras.lang.${l}";
        path = LazyVim + /lua/lazyvim/plugins/extras/lang + "/${l}"; # h
      })
      [
        "markdown"
        "nix"
        "python"
        "rust"
        "tex"
      ];
  lazyVim.plugins.formatting = [
    conform-nvim
    mason-nvim
  ];
  lazyVim.plugins.linting = [ nvim-lint ];
  lazyVim.plugins.lsp = [
    mason-lspconfig-nvim
    mason-nvim
    nvim-lspconfig
  ];
  lazyVim.plugins.treesitter = [
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-ts-autotag
  ];
  lazyVim.plugins.ui = [
    bufferline-nvim
    lualine-nvim
    mini-icons
    noice-nvim
    nui-nvim
    snacks-nvim
  ];
  lazyVim.plugins.util = [
    persistence-nvim
    plenary-nvim
    snacks-nvim
  ];
  lazyVim.final = [
    LazyVim
  ]
  ++ lazyVim.lang.markdown
  ++ lazyVim.lang.nix
  ++ lazyVim.lang.python
  ++ lazyVim.lang.rust
  ++ lazyVim.lang.tex
  # ++ lazyVim.lang.wgsl
  ++ lazyVim.plugins.coding
  ++ lazyVim.plugins.colorscheme
  ++ lazyVim.plugins.editor
  ++ lazyvim.plugins.extras.lang
  ++ lazyVim.plugins.formatting
  ++ lazyVim.plugins.linting
  ++ lazyVim.plugins.lsp
  ++ lazyVim.plugins.treesitter
  ++ lazyVim.plugins.ui
  ++ lazyVim.plugins.util;
in
lib.lists.unique [
  colortils-nvim
  image-nvim
  # iron-nvim
  luasnip-latex-snippets-nvim
  LuaSnip
  mini-base16
  # molten-nvim
  neo-tree-nvim
  # neorg
  nvim-cmp
  nvim-dap
  nvim-lspconfig
  nvim-treesitter
  # vim-repeat
  # vim-surround
  vimtex
  which-key-nvim
  # wrapwidth
  # zotcite
]
++ lazyVim.final
