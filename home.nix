# If home-manager as a shell command disappears, use this:
# nix run github:nix-community/home-manager -- switch --flake .
#
# Hint: you need `programs.home-manager.enable = true;`
# Hint: run `nix eval --impure --expr '(import <nixpkgs>{}).system'` to check current system for pkgs.system
{
  # inputs,
  # outputs,
  pkgs,
  lib,
  # config,
  ...
}:
let
  inherit (pkgs) stdenv;
  env = {
    defaultbrowser = "firefox"; # TODO: actually hook this up right
  };
in
{
  # This is required information for home-manager to do its job
  home = {
    stateVersion = "23.11"; # no touchy
    username = "ben";
    homeDirectory = "/Users/ben";
    # map `./modules/config` dir to `~/.config` dir
    file.".config" = {
      source = ./config;
      recursive = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _pkg: true;

  xdg.enable = true; # Tell programs to use ~/.config
  programs.home-manager.enable = true; # let home-manager manager itself

  nixpkgs.overlays = import ./overlays { };

  # TODO: Module each of these packages
  home.packages = with pkgs; [
    curl
    # electricsheep
    fzf
    lazygit
    mkvtoolnix
    # qbittorrent
    subs2cia
    wget
  ];

  # TODO: Module defaultBrowser
  home.activation = {
    defaultBrowser = lib.mkIf stdenv.hostPlatform.isDarwin (
      lib.hm.dag.entryAfter [ "installPackages" ] ''
        run echo "Setting default browser to ${env.defaultbrowser}"
        # set default browser
        run ${pkgs.defaultbrowser}/bin/defaultbrowser ${env.defaultbrowser}
      ''
    );
  };

  programs.git.enable = true;
  programs.tex.enable = true;
  programs.nh.enable = true;
  programs.java.enable = true;
  programs.vscode.enable = false;
  services.dock.enable = true;

  # TODO: get a Nix devenv going
  # and make it automatically initiate in ~/.nix (and other places)
  devenv.nixfmt.enable = true;
  devenv.statix.enable = true;

  imports = [
    ./modules/top-level/all-modules.nix
    ./config

    ./aesthetics/colors/swamp/light
    ./aesthetics/eyecandy/colorscripts.nix
    ./aesthetics/eyecandy/fastfetch.nix
  ];

  # Module stylix things
  stylix.enable = true;

}
