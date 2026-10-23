-- local M = {}

-- function M.setup(args)
--local hm_pluginFarm = args.hm_pluginFarm
--local hm_installed = args.hm_installed

-- https://stackoverflow.com/a/11130774/16755079
-- dir_abs_path:string -> file_name:string[]
-- list file names in the directory
local function scandir(directory)
  if not directory then
    return nil
  end

  local i, t, popen = 0, {}, io.popen
  -- Nix stdenv provides GNU coreutils
  -- GNU coreutils provides ls
  local pfile = popen('ls -A "' .. directory .. '"')
  if not pfile then
    return nil
  end
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end

local function inPaths(plugin, paths)
  local name = plugin.name
  for _, path in ipairs(paths) do
    -- check if plugin in path
    for _, plug in ipairs(scandir(path) or {}) do
      if plug == name then
        return path .. "/" .. name
      end
    end
  end
end

require("lazy").setup({
  spec = {
    -- lazyvim.plugins should be loaded frst
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },

  dev = {
    path = args.hm_pluginFarm, --function(plugin)
    -- Already downloaded plugins with Home Manager
    --return inPaths(plugin, { args.hm_pluginFarm }) or ("~/projects" .. plugin.name)
    --end,
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
