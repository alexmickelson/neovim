-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options
-- ============================================================
do
	vim.loader.enable() -- Enable faster startup by caching compiled Lua modules

	-- See `:help mapleader`
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.g.have_nerd_font = true

	-- [[ Setting options ]]
	--  See `:help vim.o`
	-- NOTE: You can change these options as you wish!
	--  For more options, you can see `:help option-list`

	vim.o.number = true
	-- vim.o.relativenumber = true -- relative line numbers

	-- mouse
	vim.o.mouse = "a" -- mouse mode
	vim.o.mousescroll = "ver:1,hor:3"
	vim.keymap.set("n", "<ScrollWheelDown>", "<C-e>")
	vim.keymap.set("n", "<ScrollWheelUp>", "<C-y>")

	vim.o.showmode = false
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
		-- if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
		-- 	local osc52 = require("vim.ui.clipboard.osc52")
		-- 	vim.g.clipboard = {
		-- 		name = "OSC 52",
		-- 		copy = { ["+"] = osc52.copy("*") },
		-- 		paste = { ["+"] = osc52.paste("*") },
		-- 	}
		-- end
	end)
	vim.o.breakindent = true
	vim.o.undofile = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.signcolumn = "yes"
	vim.o.updatetime = 250
	vim.o.timeoutlen = 300
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.tabstop = 2
	vim.o.shiftwidth = 2
	vim.o.expandtab = true

	-- Sets how neovim will display certain whitespace characters in the editor.
	--  See `:help 'list'`
	--  and `:help 'listchars'`
	--
	--  Notice listchars is set using `vim.opt` instead of `vim.o`.
	--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
	--   See `:help lua-options`
	--   and `:help lua-guide-options`
	vim.o.list = true
	--vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
	--vim.opt.listchars = { tab = '➫ ', trail = '·', nbsp = '␣' }
	vim.opt.listchars = { tab = "➩ ", trail = "·", nbsp = "␣" }

	vim.o.inccommand = "split" -- substitution preview
	vim.o.cursorline = true
	-- Minimal number of screen lines to keep above and below the cursor.
	vim.o.scrolloff = 10
	vim.o.confirm = true
end

-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- basic keymaps, basic autocmds
-- ============================================================
do
	-- [[ Basic Keymaps ]]
	--  See `:help vim.keymap.set()`

	-- Clear highlights on search when pressing <Esc> in normal mode
	--  See `:help hlsearch`
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
	-- capital Q! counts like q!
	vim.cmd([[
    command! -bang Q q<bang>
    command! -bang Qa qa<bang>
  ]])

	-- Diagnostic Config & Keymaps
	--  See `:help vim.diagnostic.Opts`
	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },

		-- Can switch between these as you prefer
		virtual_text = true, -- Text shows up at the end of the line
		virtual_lines = false, -- Text shows up underneath the line, with virtual lines

		-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})

	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
	-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
	-- is not what someone will guess without a bit more experience.
	--
	-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
	-- or just use <C-\><C-n> to exit terminal mode
	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

	-- TIP: Disable arrow keys in normal mode
	vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
	vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
	vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
	vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

	-- Keybinds to make split navigation easier.
	--  Use CTRL+<hjkl> to switch between windows
	--
	--  See `:help wincmd` for a list of all window commands
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
	-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
	-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
	-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
	-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

	-- [[ Basic Autocommands ]]
	--  See `:help lua-guide-autocommands`

	-- Highlight when yanking (copying) text
	--  Try it with `yap` in normal mode
	--  See `:help vim.hl.on_yank()`
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})
end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
	require("guess-indent").setup({})

	-- See `:help gitsigns` to understand what each configuration key does.
	require("gitsigns").setup({
		signs = {
			add = { text = "+" }, ---@diagnostic disable-line: missing-fields
			change = { text = "~" }, ---@diagnostic disable-line: missing-fields
			delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
			topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
			changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
		},
	})

	-- Useful plugin to show you pending keybinds.
	require("which-key").setup({
		-- Delay between pressing a key and opening which-key (milliseconds)
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		-- Document existing key chains
		spec = {
			{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } }, -- Enable gitsigns recommended keymaps first
			{ "gr", group = "LSP Actions", mode = { "n" } },
		},
	})

	-- [[ Colorscheme ]]
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	---@diagnostic disable-next-line: missing-fields
	require("tokyonight").setup({
		styles = {
			comments = { italic = false }, -- Disable italics in comments
		},
	})

	-- Load the colorscheme here.
	-- Like many other themes, this one has different styles, and you could load
	-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
	vim.cmd.colorscheme("tokyonight-night")

	-- Highlight todo, notes, etc in comments
	require("todo-comments").setup({ signs = false })

	-- [[ mini.nvim ]]
	--  A collection of various small independent plugins/modules

	-- If a nerd font is available, load the icons module for pretty icons in various plugins.
	if vim.g.have_nerd_font then
		require("mini.icons").setup()
		-- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
		MiniIcons.mock_nvim_web_devicons()
	end

	-- Better Around/Inside textobjects
	--
	-- Examples:
	--  - va)  - [V]isually select [A]round [)]paren
	--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
	--  - ci'  - [C]hange [I]nside [']quote
	require("mini.ai").setup({
		-- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
		mappings = {
			around_next = "aa",
			inside_next = "ii",
		},
		n_lines = 500,
	})

	-- Add/delete/replace surroundings (brackets, quotes, etc.)
	--
	-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
	-- - sd'   - [S]urround [D]elete [']quotes
	-- - sr)'  - [S]urround [R]eplace [)] [']
	require("mini.surround").setup()

	-- Simple and easy statusline.
	--  You could remove this setup call if you don't like it,
	--  and try some other statusline plugin
	local statusline = require("mini.statusline")
	-- Set `use_icons` to true if you have a Nerd Font
	statusline.setup({ use_icons = vim.g.have_nerd_font })

	-- You can configure sections in the statusline by overriding their
	-- default behavior. For example, here we set the section for
	-- cursor location to LINE:COLUMN
	---@diagnostic disable-next-line: duplicate-set-field
	statusline.section_location = function()
		return "%2l:%-2v"
	end

	-- ... and there is more!
	--  Check out: https://github.com/nvim-mini/mini.nvim
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
	-- [[ Fuzzy Finder (files, lsp, etc) ]]
	--
	-- Telescope is a fuzzy finder that comes with a lot of different things that
	-- it can fuzzy find! It's more than just a "file finder", it can search
	-- many different aspects of Neovim, your workspace, LSP, and more!
	--
	-- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
	-- so feel free to experiment and see what you like!
	--
	-- The easiest way to use Telescope, is to start by doing something like:
	--  :Telescope help_tags
	--
	-- After running this command, a window will open up and you're able to
	-- type in the prompt window. You'll see a list of `help_tags` options and
	-- a corresponding preview of the help.
	--
	-- Two important keymaps to use while in Telescope are:
	--  - Insert mode: <c-/>
	--  - Normal mode: ?
	--
	-- This opens a window that shows you all of the keymaps for the current
	-- Telescope picker. This is really useful to discover what Telescope can
	-- do as well as how to actually do it!

	-- See `:help telescope` and `:help telescope.setup()`
	require("telescope").setup({
		-- You can put your default mappings / updates / etc. in here
		--  All the info you're looking for is in `:help telescope.setup()`
		--
		-- defaults = {
		--   mappings = {
		--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
		--   },
		-- },
		-- pickers = {}
		extensions = {
			["ui-select"] = { require("telescope.themes").get_dropdown() },
		},
	})

	-- Enable Telescope extensions if they are installed
	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")

	-- See `:help telescope.builtin`
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

	-- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
	-- If you later switch picker plugins, this is where to update these mappings.
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
		callback = function(event)
			local buf = event.buf

			-- Find references for the word under your cursor.
			vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

			-- Jump to the implementation of the word under your cursor.
			-- Useful when your language has ways of declaring types without an actual implementation.
			vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })

			-- Jump to the definition of the word under your cursor.
			-- This is where a variable was first declared, or where a function is defined, etc.
			-- To jump back, press <C-t>.
			vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })

			-- Fuzzy find all the symbols in your current document.
			-- Symbols are things like variables, functions, types, etc.
			vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })

			-- Fuzzy find all the symbols in your current workspace.
			-- Similar to document symbols, except searches over your entire project.
			vim.keymap.set(
				"n",
				"gW",
				builtin.lsp_dynamic_workspace_symbols,
				{ buffer = buf, desc = "Open Workspace Symbols" }
			)

			-- Jump to the type of the word under your cursor.
			-- Useful when you're not sure what type a variable is and you want to see
			-- the definition of its *type*, not where it was *defined*.
			vim.keymap.set(
				"n",
				"grt",
				builtin.lsp_type_definitions,
				{ buffer = buf, desc = "[G]oto [T]ype Definition" }
			)
		end,
	})

	-- Override default behavior and theme when searching
	vim.keymap.set("n", "<leader>/", function()
		-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	-- It's also possible to pass additional configuration options.
	--  See `:help telescope.builtin.live_grep()` for information about particular keys
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config"), follow = true })
	end, { desc = "[S]earch [N]eovim files" })
end

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
	-- [[ LSP Configuration ]]
	-- Brief aside: **What is LSP?**
	--
	-- LSP is an initialism you've probably heard, but might not understand what it is.
	--
	-- LSP stands for Language Server Protocol. It's a protocol that helps editors
	-- and language tooling communicate in a standardized fashion.
	--
	-- In general, you have a "server" which is some tool built to understand a particular
	-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
	-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
	-- processes that communicate with some "client" - in this case, Neovim!
	--
	-- LSP provides Neovim with features like:
	--  - Go to definition
	--  - Find references
	--  - Autocompletion
	--  - Symbol Search
	--  - and more!
	--
	-- Thus, Language Servers are external tools that must be installed separately from
	-- Neovim. This configuration's Nix flake supplies them on PATH.
	--
	-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
	-- and elegantly composed help section, `:help lsp-vs-treesitter`

	-- Useful status updates for LSP.
	require("fidget").setup({})

	--  This function gets run when an LSP attaches to a particular buffer.
	--    That is to say, every time a new file is opened that is associated with
	--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
	--    function will be executed to configure the current buffer
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(event)
			-- NOTE: Remember that Lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Rename the variable under your cursor.
			--  Most Language Servers support renaming across files, etc.
			map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

			-- WARN: This is not Goto Definition, this is Goto Declaration.
			--  For example, in C this would take you to the header.
			map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method("textDocument/documentHighlight", event.buf) then
				local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
					end,
				})
			end

			-- The following code creates a keymap to toggle inlay hints in your
			-- code, if the language server you are using supports them
			--
			-- This may be unwanted, since they displace some of your code
			if client and client:supports_method("textDocument/inlayHint", event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end,
	})

	-- Enable the following language servers.
	-- They are installed by the Nix flake and discovered on PATH.
	--  See `:help lsp-config` for information about keys and how to configure
	---@type table<string, vim.lsp.Config>
	local servers = {
		-- ansiblels = {},
		bashls = {},
		-- clangd = {},
		gopls = {
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				if fname:match("^diffview://") then
					return
				end

				local root = vim.fs.root(bufnr, { "go.work", "go.mod", ".git" })
				if root then
					on_dir(root)
				end
			end,
			settings = {
				gopls = {
					hoverKind = "FullDocumentation",
					semanticTokens = true,
					semanticTokenTypes = { -- let treesitter handle these
						string = false,
						number = false,
					},
				},
			},
		},
		pyright = {},
		rust_analyzer = {},
		--
		-- Some languages (like typescript) have entire language plugins that can be useful:
		--    https://github.com/pmizio/typescript-tools.nvim
		--
		-- But for many setups, the LSP (`ts_ls`) will work just fine
		ts_ls = {},
		nixd = {
			settings = {
				nixd = {
					formatting = {
						command = { "nixfmt" },
					},
				},
			},
		},
		-- Special Lua Config, as recommended by neovim help docs
		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
				client.config.settings.Lua = vim.tbl_deep_extend("force", current_settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = { "lua/?.lua", "lua/?/init.lua" },
					},
					workspace = {
						checkThirdParty = false,
						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
						library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						}),
					},
				})
			end,
			---@type lspconfig.settings.lua_ls
			settings = {
				Lua = {
					format = { enable = false }, -- Disable formatting (formatting is done by stylua)
				},
			},
		},
	}

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		vim.lsp.enable(name)
	end
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
	-- [[ Formatting ]]
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- You can specify filetypes to autoformat on save here:
			local enabled_filetypes = {
				lua = true,
				go = true,
				nix = true,
				python = true,
				rust = true,
			}
			if enabled_filetypes[vim.bo[bufnr].filetype] then
				return { timeout_ms = 500 }
			else
				return nil
			end
		end,
		default_format_opts = {
			lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
		},
		-- You can also specify external formatters in here.
		formatters_by_ft = {
			rust = { "rustfmt" },
			yaml = { "yamlfmt" },
			["yaml.ansible"] = { "yamlfmt" },
			-- Conform can also run multiple formatters sequentially
			python = { "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list

			lua = { "stylua" },
			go = { "gofmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			json = { "jq" },
			nix = { "nixfmt" },
			bash = { "shfmt" },
			sh = { "shfmt" },
		},
	})

	vim.keymap.set({ "n", "v" }, "<leader>f", function()
		require("conform").format({ async = true })
	end, { desc = "[F]ormat buffer" })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
	-- [[ Snippet Engine ]]

	require("luasnip").setup({})

	-- `friendly-snippets` contains a variety of premade snippets.
	--    See the README about individual language/framework/plugin snippets:
	--    https://github.com/rafamadriz/friendly-snippets
	--
	-- require('luasnip.loaders.from_vscode').lazy_load()

	-- [[ Autocomplete Engine ]]
	require("blink.cmp").setup({
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See `:help blink-cmp-config-keymap` for defining your own keymap
			preset = "default",

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { "lsp", "path", "snippets" },
		},

		snippets = { preset = "luasnip" },

		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
		-- which automatically downloads a prebuilt binary when enabled.
		--
		-- By default, we use the Lua implementation instead, but you may enable
		-- the rust implementation via `'prefer_rust_with_warning'`
		--
		-- See `:help blink-cmp-config-fuzzy` for more information
		fuzzy = { implementation = "lua" },

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },
	})
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
	-- [[ Configure Treesitter ]]
	--  Used to highlight, edit, and navigate code
	--
	--  See `:help nvim-treesitter-intro`

	---@param buf integer
	---@param language string
	local function treesitter_try_attach(buf, language)
		-- Check if a parser exists and load it
		if not vim.treesitter.language.add(language) then
			return
		end
		-- Enable syntax highlighting and other treesitter features
		vim.treesitter.start(buf, language)

		-- Enable treesitter based folds
		-- For more info on folds see `:help folds`
		-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		-- vim.wo.foldmethod = 'expr'

		-- Check if treesitter indentation is available for this language, and if so enable it
		-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

		-- Enable treesitter based indentation
		if has_indent_query then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = require("nvim-treesitter").get_available()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = require("nvim-treesitter").get_installed("parsers")

			treesitter_try_attach(buf, language)
			-- if vim.tbl_contains(installed_parsers, language) then
			-- 	-- Enable the parser if it is already installed
			-- 	treesitter_try_attach(buf, language)
			-- elseif not vim.tbl_contains(available_parsers, language) then
			-- 	-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
			-- 	treesitter_try_attach(buf, language)
			-- end
		end,
	})
end

-- ============================================================
-- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
	-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug'
	-- require 'kickstart.plugins.indent_line'
	-- require 'kickstart.plugins.lint'
	-- require 'kickstart.plugins.autopairs'
	-- require 'kickstart.plugins.neo-tree'
	-- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

	-- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- require 'custom.plugins'
end

do
	require("mini.pairs").setup()

	-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
	vim.keymap.set("i", "<C-a>", "<C-o>$", { desc = "jump to end of line" })
	vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
	vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
	-- go likes tabs, so we make them two spaces
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "go",
		callback = function()
			vim.o.tabstop = 2
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function()
			vim.bo.tabstop = 4
			vim.bo.shiftwidth = 4
		end,
	})
end

do
	local api = require("nvim-tree.api")
	local last_editor_window
	local function is_editor_window(winid)
		if not vim.api.nvim_win_is_valid(winid) or vim.api.nvim_win_get_config(winid).relative ~= "" then
			return false
		end
		return vim.bo[vim.api.nvim_win_get_buf(winid)].filetype ~= "NvimTree"
	end
	local function is_tree_window(winid)
		return vim.api.nvim_win_is_valid(winid) and vim.bo[vim.api.nvim_win_get_buf(winid)].filetype == "NvimTree"
	end

	local recent_editor_group = vim.api.nvim_create_augroup("nvim_tree_recent_editor_window", { clear = true })
	vim.api.nvim_create_autocmd("WinEnter", {
		group = recent_editor_group,
		callback = function()
			local winid = vim.api.nvim_get_current_win()
			if is_editor_window(winid) then
				last_editor_window = winid
			end
		end,
	})

	local function most_recent_editor_window()
		if last_editor_window and is_editor_window(last_editor_window) then
			return last_editor_window
		end
		for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if is_editor_window(winid) then
				return winid
			end
		end
	end

	-- This is a native Neovim popup menu, matching the style of the default
	-- right-click menu (Inspect, Paste, Select All, ...).
	vim.cmd([[
    silent! aunmenu NvimTreePopUp
    nnoremenu <silent> NvimTreePopUp.Open                         :<C-u>lua require('nvim-tree.api').node.open.edit()<CR>
    nnoremenu <silent> NvimTreePopUp.Open\ in\ vertical\ split     :<C-u>lua require('nvim-tree.api').node.open.vertical()<CR>
    nnoremenu <silent> NvimTreePopUp.-1-                          <Nop>
    nnoremenu <silent> NvimTreePopUp.Copy\ relative\ path          :<C-u>lua require('nvim-tree.api').fs.copy.relative_path()<CR>
    nnoremenu <silent> NvimTreePopUp.Rename                       :<C-u>lua require('nvim-tree.api').fs.rename()<CR>
    nnoremenu <silent> NvimTreePopUp.Delete                       :<C-u>lua require('nvim-tree.api').fs.remove()<CR>
    nnoremenu <silent> NvimTreePopUp.-2-                          <Nop>
    nnoremenu <silent> NvimTreePopUp.Change\ root\ to\ selection   :<C-u>lua require('nvim-tree.api').tree.change_root_to_node()<CR>
    nnoremenu <silent> NvimTreePopUp.Refresh                      :<C-u>lua require('nvim-tree.api').tree.reload()<CR>
  ]])

	-- A global mapping is intentional: Neovim resolves a mouse mapping using
	-- the previously focused window. Resolve the clicked window ourselves so
	-- a right-click on the tree works even while an editor split has focus.
	vim.keymap.set("n", "<RightMouse>", function()
		local mouse = vim.fn.getmousepos()
		if mouse.winid > 0 and is_tree_window(mouse.winid) then
			vim.api.nvim_set_current_win(mouse.winid)
			local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(mouse.winid))
			local line = math.min(math.max(mouse.line, 1), line_count)
			local text = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(mouse.winid), line - 1, line, false)[1]
			vim.api.nvim_win_set_cursor(mouse.winid, { line, math.min(math.max(mouse.column - 1, 0), #text) })
			vim.cmd("popup NvimTreePopUp")
			return
		end
		vim.cmd("popup PopUp")
	end, { desc = "Open context menu under mouse" })

	local function tree_on_attach(bufnr)
		api.map.on_attach.default(bufnr)
	end

	require("nvim-tree").setup({
		on_attach = tree_on_attach,
		actions = {
			open_file = {
				window_picker = {
					enable = true,
					picker = most_recent_editor_window,
				},
			},
		},
		sync_root_with_cwd = true,
		filters = {
			dotfiles = false,
		},
		update_focused_file = {
			enable = true,
			update_root = {
				enable = false,
			},
		},
	})
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			require("nvim-tree.api").tree.toggle({ focus = false })
		end,
	})
	vim.keymap.set("n", "<leader>e", function()
		if api.tree.is_tree_buf() then
			api.tree.close()
		else
			api.tree.focus()
		end
	end, {
		desc = "Toggle file tree",
	})
end

do
	require("toggleterm").setup({ start_in_insert = true })

	-- Auto-enter insert mode when terminal buffer is focused (e.g., mouse click)
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function(event)
			if vim.bo[event.buf].buftype == "terminal" then
				vim.schedule(function()
					vim.cmd.startinsert()
				end)
			end
		end,
	})

	local toggle_terminal = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local name = vim.api.nvim_buf_get_name(buf)
			if name:match("toggleterm#%d+$") then
				if win == vim.api.nvim_get_current_win() then
					vim.cmd("ToggleTerm")
				else
					vim.api.nvim_set_current_win(win)
					vim.schedule(function()
						vim.cmd("startinsert")
					end)
				end
				return
			end
		end
		vim.cmd("ToggleTerm")
	end

	vim.keymap.set({ "n", "t" }, "<A-t>", toggle_terminal, { desc = "Toggle terminal" })
	-t vim.keymap.set({ "n", "t" }, "<leader>t", toggle_terminal, { desc = "Toggle terminal" })
end

-- do
--   require('bufferline').setup {
--     options = {
--       mode = 'buffers',
--       separator_style = 'slant',
--       show_buffer_close_icons = true,
--       show_close_icon = false,
--       diagnostics = 'nvim_lsp',
--     },
--   }
--   vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
--   vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })
--   vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { silent = true })
--   vim.keymap.set('n', '<leader>bc', ':bdelete<CR>', { silent = true })
-- end

do
	require("gitsigns").setup()
	local gs = require("gitsigns")
	local function diffview_local_window()
		local view = require("diffview.lib").get_current_view()
		if not view or not view.cur_layout then
			return
		end

		local RevType = require("diffview.vcs.rev").RevType
		for _, window in ipairs(view.cur_layout.windows) do
			if
				window.file
				and window.file.rev.type == RevType.LOCAL
				and type(window.id) == "number"
				and vim.api.nvim_win_is_valid(window.id)
			then
				return view, window
			end
		end
	end

	local function with_worktree_hunk(action)
		local view, window = diffview_local_window()
		if not window then
			action()
			return
		end

		vim.api.nvim_win_call(window.id, function()
			action(nil, nil, function()
				vim.schedule(function()
					if view and view.update_files then
						view:update_files()
					end
				end)
			end)
		end)
	end

	local function in_worktree_window(action)
		local _, window = diffview_local_window()
		if window then
			vim.api.nvim_win_call(window.id, action)
		else
			action()
		end
	end

	vim.keymap.set("n", "]c", function()
		in_worktree_window(gs.next_hunk)
	end, { desc = "Next Git hunk" })
	vim.keymap.set("n", "[c", function()
		in_worktree_window(gs.prev_hunk)
	end, { desc = "Previous Git hunk" })
	vim.keymap.set("n", "<leader>hn", function()
		in_worktree_window(gs.next_hunk)
	end, { desc = "Next hunk" })
	vim.keymap.set("n", "<leader>hp", function()
		in_worktree_window(gs.prev_hunk)
	end, { desc = "Previous hunk" })

	vim.keymap.set("n", "<leader>hs", function()
		with_worktree_hunk(gs.stage_hunk)
	end, { desc = "Stage hunk" })
	vim.keymap.set("v", "<leader>hs", function()
		gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, { desc = "Stage selected lines" })

	vim.keymap.set("n", "<leader>hr", function()
		with_worktree_hunk(gs.reset_hunk)
	end, { desc = "Reset hunk" })
	vim.keymap.set("v", "<leader>hr", function()
		gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, { desc = "Reset selected lines" })

	vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
	vim.keymap.set("n", "<leader>hP", gs.preview_hunk, { desc = "Preview hunk" })
	vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })

	local diffview_actions = require("diffview.actions")
	require("diffview").setup({
		keymaps = {
			view = {
				{ "n", "gf", diffview_actions.goto_file_edit, { desc = "Open file at current hunk" } },
				{ "n", "<leader>e", diffview_actions.toggle_files, { desc = "Toggle file panel" } },
				{ "n", "<leader>b", diffview_actions.focus_files, { desc = "Focus file panel" } },
			},
			file_panel = {
				{ "n", "gf", diffview_actions.goto_file_edit, { desc = "Open selected file" } },
				{ "n", "<leader>b", diffview_actions.focus_entry, { desc = "Focus selected file diff" } },
			},
		},
	})
	local diffview_open = false
	vim.keymap.set("n", "<leader>gs", function()
		if diffview_open then
			require("diffview").close()
		else
			require("diffview").open()
		end
		diffview_open = not diffview_open
	end, { desc = "[G]it [S]how Diff View (toggle)" })
end

do
	-- autosave on insert leave
	local autosave_group = vim.api.nvim_create_augroup("autosave_on_insert_leave", { clear = true })

	vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
		group = autosave_group,
		nested = true,
		desc = "Save buffer when leaving insert mode",
		callback = function(event)
			if not vim.api.nvim_buf_is_valid(event.buf) or not vim.api.nvim_buf_is_loaded(event.buf) then
				return
			end

			if
				vim.bo[event.buf].modifiable
				and not vim.bo[event.buf].readonly
				and vim.api.nvim_buf_get_name(event.buf) ~= ""
				and vim.bo[event.buf].buftype == ""
				and vim.bo[event.buf].modified
			then
				vim.api.nvim_buf_call(event.buf, function()
					vim.cmd("silent write")
				end)
			end
		end,
	})
end

do
	-- Reload files changed by another program, then refresh Git UIs from the
	-- reloaded buffer. A disk reload is not a write, so neither plugin receives
	-- its usual BufWritePost update on its own.
	vim.o.autoread = true
	local external_change_group = vim.api.nvim_create_augroup("refresh_git_after_external_change", { clear = true })

	vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
		group = external_change_group,
		callback = function()
			if vim.fn.mode() ~= "c" then
				vim.cmd("checktime")
			end
		end,
	})

	vim.api.nvim_create_autocmd("FileChangedShellPost", {
		group = external_change_group,
		callback = function(event)
			if vim.bo[event.buf].buftype ~= "" then
				return
			end

			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(event.buf) or not vim.api.nvim_buf_is_loaded(event.buf) then
					return
				end

				require("gitsigns").refresh()
				require("diffview").emit("buf_write_post")
			end)
		end,
	})
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
