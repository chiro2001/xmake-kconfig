function _list_in(li, item)
  for i = 0, #li do
    if li[i] == item then
      return true
    end
  end
  return false
end

function _split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function _init()
  if not os.exists(os.projectdir() .. "/build") then
    local mkdir_exec = "$(python) -c \"import os; os.mkdir('$(projectdir)/$(buildir)')\""
    if type(os.exec) ~= "nil" then
      print(mkdir_exec)
      os.exec(mkdir_exec)
    else
      print("run `xmake genconfig' first! To run:", mkdir_exec)
      return
    end
  end
  local path_config_file = "$(projectdir)/$(config_file)"
  local path_config_head = "$(projectdir)/$(buildir)/$(config_head)"
  if type(os.exec) == "nil" then
    path_config_file = os.projectdir() .. "/.config"
    path_config_head = os.projectdir() .. "/build/autoconf.h"
  end
  -- print("#2", os.exists(path_config_file), os.exists(path_config_head))
  if not os.exists(path_config_file) or not os.exists(path_config_head) then
    local exec = "$(python) -m genconfig --config-out $(config_file) --header-path $(buildir)/$(config_head)"
    if type(os.exec) ~= "nil" then
      cprint("${bright}Kconfig run: %s", exec)
      os.exec(exec)
    else
      print("run `xmake genconfig' first! To run:", exec)
    end
  end
end

function clean()
  os.rm("$(buildir)/$(config_head)")
  os.rm("$(projectdir)/$(config_file)")
  os.rm("$(projectdir)/$(config_file).old")
end

function load()
  _init()
  local kc = {}
  if not os.exists(os.projectdir() .. "/build") then return nil end
  local data_str = io.readfile("$(projectdir)/$(config_file)")
  local data = _split(data_str, "\n")
  for _, d in ipairs(data) do
    if string.len(d) > 0 and string.sub(d, 0, 1) ~= "#" then
      local s = _split(d, "=")
      local k = s[1]
      local v = s[2]
      if v == "y" then
        kc[k] = true
      else
        if type(tonumber(v)) ~= "nil" then
          kc[k] = tonumber(v)
        else
          if type(v) == "string" and string.sub(v, 1, 1) == "\"" then
            kc[k] = string.sub(v, 2, -2)
          else
            kc[k] = v
          end
        end
      end
    end
  end
  return kc
end
