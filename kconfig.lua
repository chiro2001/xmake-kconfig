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
  local config_file = ".config"
  local files = os.files("*")
  if not os.exists("$(buildir)/include/generated") then
    os.mkdir("$(buildir)/include/generated")
  end
  if not _list_in(files, config_file) or not os.exists("$(buildir)$(config_head)") then
    local exec = "$(python) -m genconfig --config-out $(config_file) --header-path $(buildir)$(config_head)"
    cprint("${bright}%s", exec)
    os.exec(exec)
  end
end

function load()
  _init()
  local kc = {}
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
