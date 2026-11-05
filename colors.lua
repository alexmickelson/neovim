local M = {}

local matugen_colorscheme = vim.fn.expand("~/.config/matugen/nvim-colorscheme.lua")

local function apply()
	if os.getenv("NVIM_FOLLOW_SYSTEM_STYLE") == "1" and vim.uv.fs_stat(matugen_colorscheme) then
		local ok, err = pcall(dofile, matugen_colorscheme)
		if not ok then
			vim.notify("matugen colorscheme failed: " .. err, vim.log.levels.WARN)
		end
	else
		require("tokyonight").setup({
			styles = {
				comments = { italic = false },
			},
		})
		vim.cmd.colorscheme("tokyonight-night")
	end
end

function M.setup()
	apply()

	if os.getenv("NVIM_FOLLOW_SYSTEM_STYLE") ~= "1" then
		return
	end

	local dir = vim.fs.dirname(matugen_colorscheme)
	if not vim.uv.fs_stat(dir) then
		return
	end

	local pending = false
	local watcher = vim.uv.new_fs_event()
	watcher:start(dir, {}, function(_, fname)
		if fname ~= vim.fs.basename(matugen_colorscheme) then
			return
		end
		if pending then
			return
		end
		pending = true
		vim.defer_fn(function()
			pending = false
			apply()
		end, 100)
	end)
	M.watcher = watcher
end

M.setup()

return M
