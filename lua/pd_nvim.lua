local pd = require("pd_nvim.pd")

local pd_nvim = {}

local function with_defaults(options)
  local retval = {
    pd_path = options.pd_path ~= nil or "~/src/fgspd",
    rom_id = options.rom_id ~= nil or "ntsc-final",
    keymap = {
      find_func = "<leader><c-f>F",
      find_struct = "<leader><c-f>S",
      find_define_typedef = "<leader><c-f>T",
      find_func_under_cursor = "<leader><c-f>f",
      find_struct_under_cursor = "<leader><c-f>s",
      find_define_typedef_under_cursor = "<leader><c-f>t",
      debug_perfect_dark = "<leader><c-f>d"
    }
  }
  setmetatable(retval, { __index = options })
  return retval
end

local commands = {
  { name = "PdFindFuncUnderCursor",          func = "find_func_under_cursor",           type = "lua", desc = "Find function under cursor" },
  { name = "PdFindStructUnderCursor",        func = "find_struct_under_cursor",         type = "lua", desc = "Find struct under cursor" },
  { name = "PdFindDefineTypedefUnderCursor", func = "find_define_typedef_under_cursor", type = "lua", desc = "Find Define/Typedef under cursor" },
  { name = "PdFindFunc",                     func = "find_func",                        type = "vim", desc = "Find function" },
  { name = "PdFindStruct",                   func = "find_struct",                      type = "vim", desc = "Find struct" },
  { name = "PdFindDefineTypedef",            func = "find_define_typedef",              type = "vim", desc = "Find FindDefineTypedef" },
  { name = "PdDebugPerfectDark",             func = "debug_perfect_dark",               type = "lua", desc = "Debug Perfect Dark" }
}

function pd_nvim.setup_telescope_live_grep_args()
  local telescope = require("telescope")
  local lga_actions = require("telescope-live-grep-args.actions")
  require("telescope").load_extension("live_grep_args")
  telescope.setup {
    extensions = {
      live_grep_args = {
        auto_quoting = false, -- enable/disable auto-quoting
      }
    }
  }
end

function pd_nvim.enable_keybinds()
  local keymapOptions = {}

  for _, command in ipairs(commands) do
    if command.type == "lua" then
      keymapOptions[command.func] = {
        cmd = function() pd_nvim[command.func]() end,
        desc = command.desc
      }
    elseif command.type == "vim" then
      keymapOptions[command.func] = {
        cmd = ":" .. command.name .. " ",
        desc = command.desc
      }
    end
  end

  for key, value in pairs(pd_nvim.options.keymap) do
    if keymapOptions[key] then
      vim.keymap.set('n', value, keymapOptions[key].cmd, { buffer = 0, desc = keymapOptions[key].desc })
    end
  end
end

function pd_nvim.enable_commands()
  for _, command in ipairs(commands) do
    if command.type == "lua" then
      vim.api.nvim_create_user_command(command.name, pd_nvim[command.func], {})
    elseif command.type == "vim" then
      vim.cmd(string.format("command! -nargs=1 %s lua require('pd_nvim').%s(<f-args>)", command.name, command.func))
    end
  end
end

function pd_nvim.disable_commands()
  for _, command in ipairs(commands) do
    pcall(function() vim.cmd("delcommand " .. command.name) end)
  end
end

function pd_nvim.disable_keybinds()
  for key, _ in pairs(pd_nvim.options.keymap) do
    pcall(function()
      vim.api.nvim_buf_del_keymap(0, 'n', key)
    end)
  end
end

function pd_nvim.deactivate()
  pd_nvim.disable_commands()
  pd_nvim.disable_keybinds()
end

function pd_nvim.activate()
  pd_nvim.enable_commands()
  pd_nvim.enable_keybinds()
end

-- This function is supposed to be called explicitly by users to configure this
-- plugin
function pd_nvim.setup(options)
  -- avoid setting global values outside of this function. Global state
  -- mutations are hard to debug and test, so having them in a single
  -- function/module makes it easier to reason about all possible changes
  options = options or {}
  pd_nvim.options = with_defaults(options)
  -- TODO: refactor as vim autocommands so I can assign them to groups and remove them later
  -- disable when leaving fgspd project
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" },
    {
      callback = function()
        if not string.match(vim.fn.getcwd(), "/fgspd") then -- check if the file path does not contain 'fgspd'
          pd_nvim.deactivate()
        end
      end
    }
  )
  -- enable when entering pd project
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    -- TODO: this should be the basename of the project dir in our config
    pattern = "*/fgspd*",
    callback = pd_nvim.activate
  })
  pcall(function()
    require 'which-key'.register {
      ['<c-f>'] = { name = 'Perfect Dark' }, { prefix = "<leader>" } }
  end)

  pd_nvim.setup_telescope_live_grep_args()
end

function pd_nvim.is_configured()
  return pd_nvim.options ~= nil
end

function pd_nvim.debug_perfect_dark()
  if not pd_nvim.is_configured() then
    return
  end
  pd.debug_perfect_dark(pd_nvim.options.rom_id)
end

function pd_nvim.find_func(func_name)
  if not pd_nvim.is_configured() then
    return
  end

  local find_func = pd.find_func(func_name)
end

function pd_nvim.find_func_under_cursor()
  if not pd_nvim.is_configured() then
    return
  end

  local find_func_under_cursor = pd.find_func_under_cursor()
end

function pd_nvim.find_struct(struct_name)
  if not pd_nvim.is_configured() then
    return
  end

  local find_struct = pd.find_struct(struct_name)
end

function pd_nvim.find_define_typedef(define_typedef_name)
  if not pd_nvim.is_configured() then
    return
  end

  local find_define_typedef = pd.find_define_typedef(define_typedef_name)
end

function pd_nvim.find_struct_under_cursor()
  if not pd_nvim.is_configured() then
    return
  end

  local find_struct = pd.find_struct_under_cursor()
end

function pd_nvim.find_define_typedef_under_cursor()
  if not pd_nvim.is_configured() then
    return
  end

  local find_define_typedef = pd.find_define_typedef_under_cursor()
end

return pd_nvim
