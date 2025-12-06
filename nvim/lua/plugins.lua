-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- send code to repl
		"jpalardy/vim-slime",
		keys = {
			{ "<leader>r", ":<C-u>'<,'>SlimeSend<CR>", mode = "v", desc = "Slime Send Selection" },
			{ "<leader>r", "<cmd>SlimeSendCurrentLine<CR>", mode = "n", desc = "Slime Send current line" },
		},
		config = function()
			vim.g.slime_target = "tmux"
			vim.g.slime_bracketed_paste = 1
			vim.g.slime_dont_ask_default = 1
			vim.cmd(
				[[let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": "{right}"}]]
			)
		end,
	},

  {
    "aliqyan-21/darkvoid.nvim"
  },

	{
		"wnkz/monoglow.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	-- { -- s<char><char> to target, enter to go to next, backspace to prev
	-- 	"ggandor/leap.nvim",
	-- 	config = function()
	-- 		local leap = require("leap")
	-- 		leap.set_default_mappings()
	-- 		leap.opts.preview_filter = function()
	-- 			return false
	-- 		end
	-- 		-- require("leap.user").set_repeat_keys("<enter>", "<backspace>")
	-- 	end,
	-- },
	--
	{ -- add pairs automatically
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	{ -- ysiw' -> surround word with '. cs"' -> cs " to '. ds" -> delete surrounding ".
		"tpope/vim-surround",
	},

	{ -- more extensive repeat
		"tpope/vim-repeat",
	},

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			theme = "gruvbox",
		},
	},

	{ -- readline chords in insert
		"tpope/vim-rsi",
	},
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1100,
    config = function()
      require("auto-dark-mode").setup({
        -- Optional: Configure theme names for light and dark modes
        set_dark_mode = function()
          vim.o.background = "dark"
          vim.cmd("colorscheme catppuccin-mocha")
        end,
        set_light_mode = function()
          vim.o.background = "light"
          vim.cmd("colorscheme catppuccin-latte")
        end,
        -- Optional: Adjust check frequency (in milliseconds)
        update_interval = 1000,
        -- Optional: Fallback appearance if detection fails
        fallback = "dark",
      })
    end,
  },

	{
		"stevearc/oil.nvim",
		opts = {
			use_default_keymaps = false,
			skip_confirm_for_simple_edits = true,
			delete_to_trash = true,
			keymaps = {
				["<leader>o?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<leader>ov"] = { "actions.select", opts = { vertical = true } },
				["<leader>oh"] = { "actions.select", opts = { horizontal = true } },
				["<leader>op"] = "actions.preview",
				["<leader>oc"] = { "actions.close", mode = "n" },
				["<leader>or"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["<leader>o."] = { "actions.toggle_hidden", mode = "n" },
				["<leader>o\\"] = { "actions.toggle_trash", mode = "n" },
			},
			view_options = {
				show_hidden = true,
			},
		},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
	},

  {
      'MeanderingProgrammer/render-markdown.nvim',
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {},
  },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- bigfile = { enabled = true },
			-- dashboard = { enabled = true },
			explorer = { enabled = true },
			-- indent = { enabled = true },
			-- input = { enabled = true },
			-- notifier = {
			-- 	enabled = true,
			-- 	timeout = 3000,
			-- },
			picker = { enabled = true },
			-- quickfile = { enabled = true },
			-- scope = { enabled = true },
			-- scratch = { enabled = true },
			-- scroll = { enabled = true },
			-- statuscolumn = { enabled = true },
			-- words = { enabled = true },
			styles = {
				notification = {
					-- wo = { wrap = true } -- Wrap notifications
				},
			},
		},
		keys = {
			{ "<leader><leader>", function() require("snacks").picker() end, desc = "Show all pickers", },
			-- Top Pickers & Explorer
			{ "<leader>b", function() require("snacks").picker.buffers({ current = false }) end, desc = "Buffers", },
			{ "<leader>/", function() require("snacks").picker.grep() end, desc = "Grep", },
			{ "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History", },
			{ "<leader>n", function() require("snacks").picker.notifications() end, desc = "Notification History", },
			{ "<leader>ef", function() require("snacks").explorer() end, desc = "File Explorer", },
			-- find
			{ "<c-p>", function() require("snacks").picker.files() end, desc = "Find Files", },
			{ "<leader>fg", function() require("snacks").picker.git_files() end, desc = "Find Git Files", },
			{ "<leader>fp", function() require("snacks").picker.projects() end, desc = "Projects", },
			{ "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent", },
			-- git
			{ "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git Branches", },
			{ "<leader>gl", function() require("snacks").picker.git_log() end, desc = "Git Log", },
			{ "<leader>gL", function() require("snacks").picker.git_log_line() end, desc = "Git Log Line", },
			{ "<leader>gs", function() require("snacks").picker.git_status() end, desc = "Git Status", },
			{ "<leader>gS", function() require("snacks").picker.git_stash() end, desc = "Git Stash", },
			{ "<leader>gd", function() require("snacks").picker.git_diff() end, desc = "Git Diff (Hunks)", },
			{ "<leader>gf", function() require("snacks").picker.git_log_file() end, desc = "Git Log File", },
			-- Grep
			{ "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines", },
			{ "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers", },
			{ "<leader>sg", function() require("snacks").picker.grep() end, desc = "Grep", },
			{ "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" }, },
			-- search
			{ '<leader>s"', function() require("snacks").picker.registers() end, desc = "Registers", },
			{ "<leader>s/", function() require("snacks").picker.search_history() end, desc = "Search History", },
			{ "<leader>sa", function() require("snacks").picker.autocmds() end, desc = "Autocmds", },
			{ "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines", },
			{ "<leader>sc", function() require("snacks").picker.command_history() end, desc = "Command History", },
			{ "<leader>sC", function() require("snacks").picker.commands() end, desc = "Commands", },
			{ "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics", },
			{ "<leader>sD", function() require("snacks").picker.diagnostics_buffer() end, desc = "Buffer Diagnostics", },
			{ "<leader>sh", function() require("snacks").picker.help() end, desc = "Help Pages", },
			{ "<leader>sH", function() require("snacks").picker.highlights() end, desc = "Highligsts", },
			{ "<leader>si", function() require("snacks").picker.icons() end, desc = "Icons", },
			{ "<leader>sj", function() require("snacks").picker.jumps() end, desc = "Jumps", },
			{ "<leader>sk", function() require("snacks").picker.keymaps() end, desc = "Keymaps", },
			{ "<leader>sl", function() require("snacks").picker.loclist() end, desc = "Location List", },
			{ "<leader>sm", function() require("snacks").picker.marks() end, desc = "Marks", },
			{ "<leader>sM", function() require("snacks").picker.man() end, desc = "Man Pages", },
			{ "<leader>sp", function() require("snacks").picker.lazy() end, desc = "Search for Plugin Spec", },
			{ "<leader>sq", function() require("snacks").picker.qflist() end, desc = "Quickfix List", },
			{ "<leader>sR", function() require("snacks").picker.resume() end, desc = "Resume", },
			{ "<leader>su", function() require("snacks").picker.undo() end, desc = "Undo History", },
			{ "<leader>uC", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes", },
			-- LSP
			{ "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition", },
			{ "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Declaration", },
			-- { "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References", },
			{ "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation", },
			{ "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition", },
			{ "<leader>sS", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols", },
			{ "<leader>ss", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols", },
			-- Other
			-- { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }, },
			-- { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" }, },
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						require("snacks").debug.inspect(...)
					end
					_G.bt = function()
						require("snacks").debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
					require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					require("snacks").toggle.diagnostics():map("<leader>ud")
					require("snacks").toggle.line_number():map("<leader>ul")
					require("snacks").toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					require("snacks").toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					require("snacks").toggle.inlay_hints():map("<leader>uh")
					require("snacks").toggle.indent():map("<leader>ug")
					require("snacks").toggle.dim():map("<leader>uD")
				end,
			})
		end,
	},

	-- { -- tmux navigation seemless with nvim
	-- 	"christoomey/vim-tmux-navigator",
	-- 	cmd = {
	-- 		"TmuxNavigateLeft",
	-- 		"TmuxNavigateDown",
	-- 		"TmuxNavigateUp",
	-- 		"TmuxNavigateRight",
	-- 		"TmuxNavigatePrevious",
	-- 		"TmuxNavigatorProcessList",
	-- 	},
	-- 	keys = {
	-- 		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
	-- 		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
	-- 		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
	-- 		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
	-- 		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	-- 	},
	-- },

  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
  },

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
        "python",
        "go",
        "c_sharp",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				update_in_insert = false, -- so diags are updated on insertLeave
				severity_sort = true,
				-- virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
				-- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
				float = {
					focusable = false,
					severity = { min = "INFO", max = "ERROR" },
					style = "minimal",
					border = "rounded",
					source = "if_many",
				},
				underline = true,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = {
								disable = { "missing-fields" },
								globals = { "Snacks" },
							},
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_enable = true,
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f=",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = false,
			-- format_on_save = function(bufnr)
			-- 	-- Disable "format_on_save lsp_fallback" for languages that don't
			-- 	-- have a well standardized coding style. You can add additional
			-- 	-- languages here or re-enable it for the disabled ones.
			-- 	local disable_filetypes = { c = true, cpp = true }
			-- 	local lsp_format_opt
			-- 	if disable_filetypes[vim.bo[bufnr].filetype] then
			-- 		lsp_format_opt = "never"
			-- 	else
			-- 		lsp_format_opt = "fallback"
			-- 	end
			-- 	return {
			-- 		timeout_ms = 500,
			-- 		lsp_format = lsp_format_opt,
			-- 	}
			-- end,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				sql = { "pg_format" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,noselect" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					-- ["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					-- ["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.

					-- ["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{
						name = "lazydev",
						-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
						group_index = 0,
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
				},
			})

			-- If you want insert `(` after select function or method item
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"ellisonleao/gruvbox.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = true,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "hard", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = { },
        dim_inactive = false,
        transparent_mode = false,
      })
      -- require("gruvbox").load()
    end
	},
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "latte",
        no_italic = false,
        no_bold = false,
        show_end_of_buffer = true,
        float = {
          transparent = true, -- enable transparent floating windows
          solid = true, -- use solid styling for floating windows, see |winborder|
        },
      })
      -- require("catppuccin").load()
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup({
          compile = false,             -- enable compiling the colorscheme
          undercurl = true,            -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true},
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = false,         -- do not set background color
          dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
          terminalColors = true,       -- define vim.g.terminal_color_{0,17}
          colors = {                   -- add/modify theme and palette colors
              palette = {},
              theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
          },
          overrides = function(colors) -- add/modify highlights
              return {}
          end,
          theme = "dragon",              -- Load "wave" theme
          background = {               -- map the value of 'background' option to a theme
              dark = "dragon",           -- try "dragon" !
              light = "lotus"
          },
      })
      -- require("kanagawa").load()
    end
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup  {
          -- Main options --
          style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
          transparent = false,  -- Show/hide background
          term_colors = true, -- Change terminal color as per the selected theme style
          ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
          cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

          -- toggle theme style ---
          toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
          toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

          -- Change code style ---
          -- Options are italic, bold, underline, none
          -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
          code_style = {
              comments = 'italic',
              keywords = 'none',
              functions = 'none',
              strings = 'italic,bold',
              variables = 'none'
          },

          -- Lualine options --
          lualine = {
              transparent = false, -- lualine center bar transparency
          },

          -- Custom Highlights --
          colors = {}, -- Override default colors
          highlights = {}, -- Override highlight groups

          -- Plugins Config --
          diagnostics = {
              darker = true, -- darker colors for diagnostic
              undercurl = true,   -- use undercurl instead of underline for diagnostics
              background = true,    -- use background color for virtual text
          },
      }
      -- Enable theme
      -- require('onedark').load()
    end
  },

	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
})

vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
