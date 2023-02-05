local M = {}

M.lsp_node_type_data = ""

M.treesitter_get_node_type = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local parser = vim.treesitter.get_parser(bufnr)

	local row, col = cursor[1], cursor[2] + 1

	local ret

	parser:for_each_tree(function(tree)
		if ret then
			return
		end

		local root = tree:root()

		if root then
			local node = root:descendant_for_range(row - 1, col - 1, row - 1, col - 1)

			if node and node ~= root then
				ret = node
			end
		end
	end)

	if not ret then
		return ""
	end

	--local typ = ret:symbol()
	return ret:type()
end

M.lsp_update_node_type = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local bufname = vim.api.nvim_buf_get_name(bufnr)

	local params = {
		textDocument = { uri = bufname },
		position = { line = cursor[1] - 1, character = cursor[2] },
	}

	vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result, _, _)
		if err then
			error(tostring(err))
		end

		if not result then
			M.lsp_node_type_data = ""
			return
		end
		-- FIXME:
		-- * more tests around this?
		M.lsp_node_type_data = result
	end)
end

local parse_lsp_node_type = function()
	local contents = M.lsp_node_type_data.contents

	if contents == nil then
		return ""
	end

	local lsp_node_type_markdown = contents.value

	if lsp_node_type_markdown == nil then
		return ""
	end

	-- Example LSP responses..
	-- "```python\n(function) main() -> None\n```"
	-- "```python\n(variable) args: Namespace\n```"
	-- "```python\n(variable) bar: Literal['asdasdasdasda']\n```"
	-- "```python\n(variable) app: Any\n```"
	-- "```python\n(function) _environments(environments: list[Unknown], values_directory: str) -> list[Unknown]\n```"
	-- "```python\n(function)\nprint(*values: object, sep: str | None = ..., end: str ...
	-- "```python\n(function) exit(code: _ExitCode = ...) -> NoReturn\n```"
	-- "```python\n(class) Path(*args: StrPath, **kwargs: Any)\n```\n---\nConstruct a ...

	local doc = string.match(lsp_node_type_markdown, "```(.*)```")
	local first_line = string.match(doc, "%w*\n([^\n]*)")
	local node_type = string.match(first_line, "%(([^)]*)%).*")

	local first_line_fingerprint = string.gsub(first_line, "%([^)]*%) ", "")

	local first_line_fingerprint_components = vim.split(first_line_fingerprint, " ")

	local kind

	if first_line_fingerprint_components[2] == "->" then
		kind = first_line_fingerprint_components[3]
	else
		kind = first_line_fingerprint_components[2]
		if kind then
			kind = string.match(kind, "(%w*)")
		end
	end

	if kind == nil then
		kind = "unknown"
	end

	return string.format("%s %s", kind, node_type)
end

M.statusline = function()
	local lsp_node_type, treesitter_node_type = M.get()
	return string.format("%s / %s", lsp_node_type, treesitter_node_type)
end

M.get = function()
	M.lsp_update_node_type()
	local treesitter_node_type = M.treesitter_get_node_type()
	local lsp_node_type = parse_lsp_node_type()
	return lsp_node_type, treesitter_node_type
end

M.setup = function()
	-- TODO:
	-- * allow custom keymap..
	vim.api.nvim_set_keymap(
		"n",
		"<leader>n",
		'<CMD>lua print(vim.inspect(require("node-type").get()))<CR>',
		{ noremap = true, silent = true }
	)
end

return M
