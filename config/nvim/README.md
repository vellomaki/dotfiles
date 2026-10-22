# Neovim

## Home Manager
> Much of the information for this is based on [azuwis's discussion post](https://github.com/LazyVim/LazyVim/discussions/1972#discussion-5826338).

While I try my best to keep my Neovim config as modular as possible, it inevitably needs some interfacing with especially the package manager and any greater configuration system. The present section discusses using [Home Manager](home-manager.dev) (itself leveraging the [Nix package manager](nixos.org)), following the standard [module system](https://nix.dev/tutorials/module-system/).

The entry point is `default.nix`. Well, strictly speaking, the "entry point" is wherever we set `programs.neovim.enable = true`: Home Manager uses this flag to determine its own handling of Neovim and so I co-opt it when adding my own config stuff. Really, this `enable` flag is all that's needed to get a bare bones Neovim setup (though I add `programs.neovim = { withPython3 = false; withRuby = false; }` on account of my older `home.stateVersion` in order to align with new behavior).

```
.
├── README.md (this file)
└── default.nix
```

[ascii-tree]: https://asciitools.com/tree?fancy=true&fullpath=false&rootdot=true&trailingdirslash=true

Once we have Neovim installed, we just need to bootstrap `init.lua`. This should be done via the `programs.neovim.initLua` option. Note that relying on `home.file.'.config'` to populate an `init.lua` will override any work Home Manager does in mutating `init.lua``.

The lazy.nvim [installation docs](https://lazy.folke.io/installation) instruct bootstrapping the plugin by cloning [the git repository](https://github.com/folke/lazy.nvim.git) into `vim.fn.stdpath("data") .. "/lazy/lazy.nvim"` (which is generally `~/.local/share/nvim/lazy/lazy.nvim`). I think this is because lazy.nvim takes a fairly different approach to plugins than native Neovim and so wants to control its own environment. Azuwis's post instead employs `pkgs.vimPlugins.lazy-nvim`.

> ! IMPORTANT (2026-10-21): As is, the config files do not engage bootstrapping in non-Nix environments. This should be handled as appropriate.

### Package downloads
One way or another, you need to have plugins on your computer to use them. By default, lazy.nvim likes to git clone plugins into the "lazy home" (e.g. `~/.local/share/nvim/lazy`). Nothing's really wrong with this, it's just awfully state-full. Following Azuwis, we could instead leverage Nix's `/nix/store`, which is where Nixpkgs normally downloads things. There seems to be two possible routes here: (1) As Azuwis does, create a `pkgs.linkFarm` and feed it to `dev = { path = "..." }` in `require('lazy').setup`. (2) Or, `performance = { rtp = { paths = {} } }`?

`dev.path` can be a function `LazyPlugin -> string` which could check if a given plugin is in our Nix store and otherwise defaults to the default (i.e. `'~/projects/' .. plugin.name`). Issue 1) 

## lazy.nvim
My Neovim config uses plugins heavily and uses the [lazy.nvim](lazy.folke.io) plugin manager.

The entry point is `init.lua` which points directly to `./lua/config/lazy.lua`.

```lua
# init.lua
require('config.lazy')
```
