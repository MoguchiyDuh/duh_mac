return {
	parsers = { "toml", "yaml", "json", "markdown", "markdown_inline", "ini", "xml", "csv" },
	lsp = {
		taplo = { bin = "taplo" },
		marksman = { bin = "marksman" },
		biome = { bin = "biome", config = { filetypes = { "json", "jsonc" } } },
	},
	format = {
		toml = { "taplo" },
		yaml = { "yamlfmt" },
		json = { "biome" },
		jsonc = { "biome" },
	},
	lint = { yaml = { "yamllint" } },
}
