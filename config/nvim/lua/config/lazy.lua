-- local M = {}

-- function M.setup(args)
--local hm_pluginFarm = args.hm_pluginFarm
--local hm_installed = args.hm_installed

require("lazy").setup({
  spec = {
    -- lazyvim.plugins should be loaded frst
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },

  dev = {
    path = function(plugin)
      -- Already downloaded plugins with Home Manager
      for _, plug in ipairs(args.hm_installed or {}) do
        if plug == plugin.name then
          print(args.hm_pluginFarm .. plugin.name)
          return args.hm_pluginFarm .. "/" .. plugin.name
        end
      end
      return "~/projects" .. plugin.name
    end,
    patterns = { "" },
    fallback = true,
  },

  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },

  -- automatically check for plugin updates --
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
--end

-- return M
