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
        -- https://stackoverflow.com/a/11130774/16755079
        -- dir_abs_path:string -> file_name:string[]
        -- list file names in the directory
        local function scandir(directory)
          local i, t, popen = 0, {}, io.popen
          -- Nix stdenv provides GNU coreutils
          -- GNU coreutils provides ls
          local pfile = popen('ls -A "' .. directory .. '"')
          for filename in pfile:lines() do
            i = i + 1
            t[i] = filename
          end
          pfile:close()
          return t
        end

        args = {}
        args.hm_pluginFarm = "${pluginFarm}"
        args.hm_installed = scandir(args.hm_pluginFarm)
        require('config.lazy')
        -- require('config.lazy').setup({hm_pluginFarm = hm_pluginFarm, hm_installed = scandir(hm_pluginFarm)})
      '';
      # builtins.readFile ./hm-init.init.lua;
      withPython3 = false;
      withRuby = false;
    };
  };
}
