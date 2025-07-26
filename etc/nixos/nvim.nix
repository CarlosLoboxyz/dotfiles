{ config, pkgs, ...}:

{
	home-manager.users.carlos = { pkgs, ... }: {
	  programs.neovim = {
			enable = true;
			viAlias = true;
			plugins = with pkgs.vimPlugins; [
				undotree
				lazy-nvim
				snacks-nvim
				gruvbox-nvim
				conform-nvim
				dropbar-nvim
				gitsigns-nvim
				telescope-nvim
				mini-pairs
				# Completion
				nvim-cmp
				cmp-nvim-lsp
				# Tree:
				neo-tree-nvim
				nvim-web-devicons
				plenary-nvim
				nui-nvim
				# LSP:
				nvim-lspconfig
				# TreeSitter:
				nvim-treesitter
			];
			extraPackages = with pkgs; [
				gcc
				vscode-langservers-extracted
				stylua
				black
				prettierd
				python313Packages.jedi-language-server
			];
			extraLuaConfig = ''
				vim.opt.number = true
				vim.opt.wrap = false
				vim.opt.hlsearch = true
				vim.opt.incsearch = true
				vim.opt.scrolloff = 5
				vim.opt.laststatus = 0
				vim.opt.splitbelow = true
				vim.opt.splitright = true
				vim.opt.colorcolumn = "80"
				vim.opt.signcolumn = "yes"
				vim.opt.cursorline = true
				vim.opt.tabstop = 2
				vim.opt.shiftwidth = 2
				vim.opt.mouse = "a"
				vim.opt.clipboard = "unnamedplus"
				vim.opt.termguicolors = true
				vim.opt.background = "dark"
				vim.opt.swapfile = false
				vim.opt.backup = false
				vim.opt.undofile = true
				vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
				vim.opt.ignorecase = true
				vim.opt.smartcase = true
				vim.opt.updatetime = 300

				vim.g.mapleader = " "

				require("lazy").setup({
					checker = { enabled = true, notify = false }, 
					spec = {
						{ import = "plugins" },
					},
					performance = {
						reset_packpath = false,
        		rtp = {
            	reset = false,
          	}
        	},
      		dev = {
						path = "${pkgs.vimUtils.packDir config.home-manager.users.carlos.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
						patterns = {""},
					},
					install = {
						missing = false,
      		},
				})

				require("config.keybindings")

				local lspconfig_defaults = require("lspconfig").util.default_config
				lspconfig_defaults.capabilities = vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
	
				local lspconfig = require("lspconfig")
				lspconfig.jedi_language_server.setup({})

				local cmp = require("cmp")
				cmp.setup({
					sources = {
						{ name = "nvim_lsp" },
					},
					mapping = cmp.mapping.preset.insert({}),
					snippet = {
						expand = function(args)
							vim.snippet.expand(args.body)
						end,
					},
				})
			'';
	  };

		xdg.configFile."nvim/lua/plugins/gruvbox.lua".text = ''
			return {
				"ellisonleao/gruvbox.nvim",
				priority = 1000,
				opts = {
					contrast = "hard",
					transparent_mode = true
				},

				config = function(_, opts)
					require("gruvbox").setup(opts)
					vim.cmd("colorscheme gruvbox")
				end
			}
		'';

		xdg.configFile."nvim/lua/plugins/conform-nvim.lua".text = ''
			return {
				'stevearc/conform.nvim',
					opts = {},
					config = function()
						require("conform").setup({
							formatters_by_ft = {
								lua = { "stylua" },
								python = { "black" },
								javascript = { "prettierd" },
								go = { "goimports" },
							},
						})

					vim.api.nvim_create_autocmd("BufWritePre", {
							pattern = "*",
							callback = function(args)
							require("conform").format({ bufnr = args.buf })
							end
							})
				end
			}
		'';

		xdg.configFile."nvim/lua/plugins/dropbar.lua".text = ''
			return {
				"Bekaboo/dropbar.nvim",
					config = function()
					end
			}
		'';

		xdg.configFile."nvim/lua/plugins/gitsigns.lua".text = ''
			return {
				"lewis6991/gitsigns.nvim",
					opts = {
						signs = {
							add = { text = "▎" },
							change = { text = "▎" },
							delete = { text = "" },
							topdelete = { text = "" },
							changedelete = { text = "▎" },
							untracked = { text = "▎" },
						},
						signs_staged = {
							add = { text = "▎" },
							change = { text = "▎" },
							delete = { text = "" },
							topdelete = { text = "" },
							changedelete = { text = "▎" },
						},
						on_attach = function(buffer)
							local gs = package.loaded.gitsigns

							local function map(mode, l, r, desc)
							vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
							end

							-- stylua: ignore start
							map("n", "]h", function()
									if vim.wo.diff then
									vim.cmd.normal({ "]c", bang = true })
									else
									gs.nav_hunk("next")
									end
									end, "Next Hunk")
							map("n", "[h", function()
									if vim.wo.diff then
									vim.cmd.normal({ "[c", bang = true })
									else
									gs.nav_hunk("prev")
									end
									end, "Prev Hunk")
							map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
							map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
							map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
							map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
							map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
							map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
							map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
							map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
							map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
							map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
							map("n", "<leader>ghd", gs.diffthis, "Diff This")
							map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
							map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
							end,
					},
			}
		'';

		xdg.configFile."nvim/lua/plugins/icons.lua".text = ''
			return { 
				"nvim-tree/nvim-web-devicons", opts = {} 
			}
		'';

		xdg.configFile."nvim/lua/plugins/lsp.lua".text = ''
			return {
				{ "neovim/nvim-lspconfig" },
			}
		'';

		xdg.configFile."nvim/lua/plugins/minipairs.lua".text = ''
			return {
				"echasnovski/mini.pairs",
					opts = {
						modes = { insert = true, command = true, terminal = false },
						skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
						skip_ts = { "string" },
						skip_unbalanced = true,
						markdown = true,
					},
			}
		'';

		xdg.configFile."nvim/lua/plugins/neotree.lua".text = ''
			return {
				"nvim-neo-tree/neo-tree.nvim",
					branch = "v3.x",
					dependencies = {
						"nvim-lua/plenary.nvim",
						"nvim-tree/nvim-web-devicons",
						"MunifTanjim/nui.nvim",
					},
					lazy = false,
					config = function()
						require("neo-tree").setup({
								popup_border_style = "single",
								})
				end
			}
		'';

		xdg.configFile."nvim/lua/plugins/snacks.lua".text = ''
			return {
				"folke/snacks.nvim",
					priority = 1000,
					lazy = false,
					opts = {
						indent = { enabled = true },
						-- statuscolumn = { enabled = true },
						dim = { enabled = true },
					},
			}
		'';

		xdg.configFile."nvim/lua/plugins/telescope.lua".text = ''
			return {
				"nvim-telescope/telescope.nvim",
					tag = "0.1.8",
					dependencies = { "nvim-lua/plenary.nvim" },
					config = function()
						require("telescope").setup({})

						local builtin = require("telescope.builtin")
						vim.keymap.set("n", "<leader>ff", builtin.find_files, {})

						vim.keymap.set("n", "<leader>fs", function()
								local word = vim.fn.expand("<cWORD>")
								builtin.grep_string({ search = vim.fn.input("Grep > ") })
								end)

						vim.keymap.set("n", "<leader>ws", function()
								local word = vim.fn.expand("<cword>")
								builtin.grep_string({ search = word })
								end)

						vim.keymap.set("n", "<leader>Ws", function()
								local word = vim.fn.expand("<cWORD>")
								builtin.grep_string({ search = word })
								end)
						end,
			}
		'';

		xdg.configFile."nvim/lua/plugins/treesitter.lua".text = ''
			return {
				"nvim-treesitter/nvim-treesitter",
					build = ":TSUpdate",
					config = function()
						local configs = require("nvim-treesitter.configs")

						configs.setup({
								ensure_installed = {},
								-- ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "python", "html", "css" },
								sync_install = false,
								highlight = { enable = true },
								indent = { enable = true },
								})
				end
			}
		'';

		xdg.configFile."nvim/lua/plugins/undotree.lua".text = ''
			return {
				"mbbill/undotree",

					config = function()
						vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
						vim.g.undotree_WindowLayout = 3
						end,
			}
		'';

		xdg.configFile."nvim/lua/config/keybindings.lua".text = ''
			-- NeoTree
			vim.keymap.set("n", "<leader>T", ":Neotree toggle<CR>")
			vim.keymap.set("n", "<leader>t", ":Neotree focus<CR>")

			-- Move Between windows
			vim.keymap.set("n", "<C-h>", "<C-w>h")
			vim.keymap.set("n", "<C-j>", "<C-w>j")
			vim.keymap.set("n", "<C-k>", "<C-w>k")
			vim.keymap.set("n", "<C-l>", "<C-w>l")

			vim.api.nvim_create_autocmd("LspAttach", {
					desc = "LSP actions",
					callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
					vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", opts)
					vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					end,
					})
		'';
	};
}
