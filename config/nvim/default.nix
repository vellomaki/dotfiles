{
  pkgs,
  lib,
  config,
  ...
}:
# let
#   linterLanguages =
#     packages: with packages; [
#       c
#       haskell
#       json
#       lua
#       markdown
#       markdown_inline
#       nix
#       python
#       rust
#       toml
#       yaml
#     ];
#
#   dependencies = with pkgs; [
#     curl
#     fd
#     fzf
#     git
#     lazygit
#     nerd-fonts._0xproto
#     ripgrep
#
#     (pkgs.vimPlugins.nvim-treesitter.withPlugins linterLanguages)
#   ];
# in
let
  pluginDir = ./lua/plugins;
  # map builtins.readFile (lib.filesystem.listFilesRecursive pluginDir)
  plugins = (import (pluginDir + /plugins.nix)) { inherit lib pkgs; };
  mkEntryFromDrv =
    drv:
    if lib.isDerivation drv then
      {
        name = "${lib.getName drv}";
        path = drv;
      }
    else
      drv;
  pluginFarm = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
in
{
  config = lib.mkIf config.programs.neovim.enable {
    # home.packages = dependencies;
    ## Get LazyVim to work with Nix and home-manager
    # https://github.com/LazyVim/LazyVim/discussions/1972#discussion-5826338
    programs.neovim = {
      # Note: extraPackages make packages available to Neovim like a simple home.packages would; but, unlike home.packages, it does not pollute the $PATH with these extra packages.
      extraPackages = with pkgs; [
        ripgrep
        tree-sitter
      ];
      # extraPackages = with pkgs; [
      #   lua-language-server
      #   stylua
      #   ripgrep
      #   imagemagick # image.nvim
      #   lua
      # ];

      # extraLuaPackages = ps: with ps; [ magick ];

      # extraPython3Packages = ps: with ps; [ pynvim ];

      plugins = with pkgs.vimPlugins; [ lazy-nvim ];
      initLua = /* lua */ ''
        args = { hm = {} }
        args.hm.spec = {
          -- [1] = { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          {[2] = {"mason-org/mason-lspconfig.nvim", enabled = false }},
          {[3] = { "mason-org/mason.nvim", enabled = false }},
          -- [4] = { import = "plugins" },
          {[5] = { "neovim/nvim-lspconfig", opts = { servers = lsp_servers }}},
          {[6] = { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } }},
        }

        args.hm.pluginFarm = "${pluginFarm}"
        require('config.lazy')
        -- require('config.lazy').setup({hm_pluginFarm = hm_pluginFarm, hm_installed = scandir(hm_pluginFarm)})
      '';
      # builtins.readFile ./hm-init.init.lua;
      withPython3 = false;
      withRuby = false;
    };

    xdg.configFile."nvim/parser".source =
      let
        parsers = pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths =
            (pkgs.vimPlugins.nvim-treesitter.withPlugins (
              p: with p; [
                latex
                lua
                markdown
                nix
              ]
            )).dependencies;
        };
      in
      "${parsers}/parser";
  };
}
