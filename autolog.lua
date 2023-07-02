local autolog = {}
autolog.old_functions = {}
autolog.logged_functions = {"print", "MsgC", "MsgN", "Msg"}

local time_stamp = os.time()
local folder_name = "autolog"
local file_name = os.date("%d_%m_%Y-%H_%M_%S") .. ".txt"
local file_path = folder_name .. "/" .. file_name

file.CreateDir(folder_name)

file.Append(file_path, "")

local function get_time() return os.date("%H:%M:%S %d.%m.%Y", os.time()) end

local function log_to_file(prefix, text)
	file.Append(file_path, "[" .. get_time() .. "][" .. prefix .. "] " .. text .. "\n")
end

for _, v in ipairs(autolog.logged_functions) do
	if not autolog.old_functions[v] then
		autolog.old_functions[v] = _G[v]
	end

	_G[v] = function(...)
		local args = {} -- args processing
		for _, v in ipairs({...}) do
			args[#args+1] = isstring(v) and v or tostring(v)
		end

		log_to_file(v, table.concat(args, "          "))
		autolog.old_functions[v](...)		
	end
end

print("Autolog initialized.")
