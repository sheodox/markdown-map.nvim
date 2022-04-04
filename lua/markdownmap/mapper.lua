local M = {}
local api = vim.api

function M.check_mappable()
	return api.nvim_buf_get_option(0, "filetype") == "markdown"
end

function M.gen_map()
	local lines = api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
	local headings = {}

	for line_number, line in ipairs(lines) do
		if vim.startswith(line, "#") then
			local heading_level = #string.match(line, "#*")
			local heading = string.match(line, "#*%s*(.*)")

			-- make sure it's a valid markdown level and not just ##########################
			if heading_level < 7 and heading ~= "" then
				table.insert(headings, {
					line_number = line_number,
					heading = heading,
					heading_level = heading_level,
				})
			end
		end
	end

	return headings
end

return M
