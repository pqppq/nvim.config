return {
	cmd = { "sourcekit-lsp" },
	filetypes = { "swift" },
	root_markers = {
		"Package.swift",
		".git",
		"compile_commands.json",
		".sourcekit-lsp",
	},
	get_language_id = function(_, ftype)
		return ftype
	end,
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
				relatedDocumentSupport = true,
			},
		},
	},
}
