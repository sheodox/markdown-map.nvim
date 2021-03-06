local M = {}
local popup = require("plenary.popup")
local plenary_window_float = require("plenary.window.float")
local mapper = require("markdownmap.mapper")
local api = vim.api

local win_id = nil

function M.close()
	if api.nvim_win_is_valid(win_id) then
		api.nvim_win_close(win_id, true)
	end
end

function M.toggle()
	if win_id ~= nil and api.nvim_win_is_valid(win_id) then
		M.close()
		return
	end

	if not mapper.check_mappable() then
		print("Markdown-map.nvim: This isn't a markdown file")
		return
	end

	local headings = mapper.gen_map()
	local md_buf_cursor_line = api.nvim_win_get_cursor(0)[1]

	local bufnr = vim.api.nvim_create_buf(false, false)
	api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
	api.nvim_buf_set_option(bufnr, "buftype", "nofile")

	local width = 50
	local height = 20

	local win
	win_id, win = popup.create(bufnr, {
		title = "Markdown Map",
		highlight = "Normal",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		padding = { 0, 0, 0, 0 },
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		borderhighlight = "FloatBorder",
		callback = function() end,
	})

	local lines = {}
	local closest_header_line = nil
	for index, value in ipairs(headings) do
		table.insert(lines, string.rep(" ", value.heading_level - 1) .. value.heading)

		if value.line_number <= md_buf_cursor_line then
			closest_header_line = index
		end
	end

	api.nvim_buf_set_option(bufnr, "modifiable", true)
	api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	api.nvim_buf_set_option(bufnr, "modifiable", false)

	for line_number, heading in ipairs(headings) do
		-- line number is zero indexed when adding highlights, need to convert
		api.nvim_buf_add_highlight(bufnr, -1, "markdownH" .. heading.heading_level, line_number - 1, 0, -1)
	end

	-- if they're under a header, set their cursor to the line nearest to it (above only)
	if closest_header_line ~= nil then
		api.nvim_win_set_cursor(0, { closest_header_line, 0 })
	end

	vim.keymap.set("n", "<esc>", function()
		M.close()
	end, {
		nowait = true,
		noremap = true,
		buffer = true,
	})

	vim.keymap.set("n", "<cr>", function()
		local cursor_row = api.nvim_win_get_cursor(win_id)[1]

		if lines[cursor_row] then
			M.close()
			api.nvim_win_set_cursor(0, { headings[cursor_row].line_number, 0 })
		end
	end, {
		nowait = true,
		noremap = true,
		buffer = true,
	})

	vim.cmd(
		string.format(
			"autocmd WinLeave,BufLeave,BufDelete <buffer=%s> ++once ++nested lua require('markdownmap.menu').close()",
			bufnr,
			bufnr
		)
	)
end

return M
