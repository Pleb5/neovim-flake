{
  description = ''A flake that creates Nixvim based on nixos-unstable'';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nixvim.url = "github:nix-community/nixvim";

    goose-nvim = {
        url = "github:azorng/goose.nvim";
        flake = false;
    };

  };

  outputs = { self, nixpkgs, flake-utils, nixvim, goose-nvim }:

    let
        # Configure Neovim
        config = {
        
        globals.mapleader = " ";
            # Undo directory and set undodir to true(long-lasting undo tree)
            extraConfigLua = ''
            vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir";
            vim.opt.undofile = true;
          
            vim.keymap.set("n", "<leader>rn", function()
                    return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true })

            -- Setup goose.nvim
            require('goose').setup({
              prefered_picker = 'telescope',
              
              default_global_keymaps = true,
              
              keymap = {
                global = {
                  toggle = '<leader>gg',                    -- Open/close goose
                  open_input = '<leader>gi',                -- Open input window
                  open_input_new_session = '<leader>gI',    -- Open input with new session
                  open_output = '<leader>go',               -- Open output window
                  open_history = '<leader>gh',              -- Open session history
                  goose_ask = '<leader>ga',                 -- Quick ask
                  goose_ask_visual = '<leader>ga',          -- Ask about visual selection
                  select_file_mention = '<leader>gf',       -- Toggle file mention
                  switch_model = '<leader>gm',              -- Switch between models
                  stop_goose = '<leader>gS',                -- Stop current goose operation (changed from gs to avoid conflict with fugitive)
                  toggle_pane = '<tab>',                    -- Toggle between panes
                  prev_prompt_history = '<up>',             -- Previous prompt in history
                  next_prompt_history = '<down>'            -- Next prompt in history
                }
              },
              
              ui = {
                window_width = 0.35,      -- Width as percentage of editor
                input_height = 0.15,      -- Input height as percentage of window
                fullscreen = false,       -- Start in fullscreen mode
                layout = "right",         -- "center" or "right"
                floating_height = 0.8,    -- Height for center layout
                display_model = true,     -- Show model name in winbar
                display_goose_mode = true -- Show mode in winbar
              },
              
              -- Configure your AI providers here after running 'goose configure' in terminal
              providers = {
                -- Example configurations:
                -- openai = {
                --   "gpt-4",
                --   "gpt-3.5-turbo"
                -- },
                -- anthropic = {
                --   "claude-3.5-sonnet",
                --   "claude-3-opus"
                -- },
                -- ollama = {
                --   "llama2",
                --   "codellama"
                -- }
              }
            })

            '';

        # Neovim basic options
        opts = {
            # Show line numbers
            number = true;
            relativenumber = true;
            scrolloff = 8;

            # Tabs

            shiftwidth = 4;
            tabstop = 4;
            softtabstop = 4;
            expandtab = true;

            clipboard = "unnamedplus";

            incsearch = true;

            colorcolumn = "80";

        };

        keymaps = [
            # My keymap

            # Normal mode
            # Current Window width - or +
            # Horizontally
            {
                mode = "n";
                key = "-";
                action = "<C-w><";
            }

            {
                mode = "n";
                key = "+";
                action = "<C-w>>";
            }
            # Vertically
            {
                mode = "v";
                key = "-";
                action = "<cmd>res -1<CR>";
            }
            {
                mode = "v";
                key = "+";
                action = "<cmd>res +1<CR>";
            }

            # jump half a page and stay in the middle of the screen
            {
                mode = "n";
                key = "<C-d>";
                action = "<C-d>zz";
            }

            {
                mode = "n";
                key = "<C-u>";
                action = "<C-u>zz";
            }
            
            {
                mode = "n";
                key = "n";
                action = "nzzzv";
            }

            {
                mode = "n";
                key = "N";
                action = "Nzzzv";
            }

            {
                mode = "n";
                key = "<leader>y";
                action = "\"+y";
            }
            
            {
                mode = "n";
                key = "<leader>o";
                action = "o<Esc>";
            }
            
            {
                mode = "n";
                key = "<leader>O";
                action = "O<Esc>";
            }

            {
                mode = "n";
                key = "<leader>d";
                action = "\"_d";
            }

            {
                mode = "n";
                key = "Q";
                action = "<nop>";
            }

            {
                mode = "n";
                key = "q";
                action = "<nop>";
            }
            
            {
                mode = "n";
                key = "<c-z>";
                action = "<nop>";
            }

            {
                mode = "n";
                key = "<leader>f";
                action = "function() vim.lsp.buf.format() end)";
            }

                    # diagnostic go to next
            {
                mode = "n";
                key = "<leader>k";
                action = "<cmd>lua vim.diagnostic.goto_next()<CR>zz";
            }

                    # diagnostic go to prev
            {
                mode = "n";
                key = "<leader>j";
                action = "<cmd>lua vim.diagnostic.goto_prev()<CR>zz";
            }

            # go to next location after gD
            {
                mode = "n";
                key = "<C-j>";
                action = "<cmd>cnext<CR>zz";
            }

            # go to prev location after gD
            { 
                mode = "n";
                key = "<C-k>";
                action = "<cmd>cprev<CR>zz";
            }
            
            # jump to location(quickfix error item like a Glog commit or a diagnostic item) under cursor
            { 
                mode = "n";
                key = "<C-l>";
                action = "<cmd>execute 'cc ' . line('.')<CR>zz";
            }


            # diagnostic open float
            { 
                mode = "n";
                key = "<leader>e";
                action = "<cmd>lua vim.diagnostic.open_float()<CR>";
            }

            # In insert-and-command-line mode this pastes text from register "
            { 
                mode = "!";
                key = "<C-b>";
                action = "<C-R><C-\">";
            }

            # In command-line mode this pastes text from register +
            { 
                mode = "c";
                key = "<C-v>";
                action = "<C-R>+";
            }

            { 
                mode = "t";
                key = "<leader>j";
                action = "<C-\\><C-n>";
            }

            # toggle Trouble
            { 
                mode = "n";
                key = "<leader>xd";
                action = "<cmd>Trouble diagnostics toggle<CR>";
            }

            { 
                mode = "n";
                key = "<leader>xx";
                action = "<cmd>Trouble<CR>";
            }

            {
                mode = "n";
                key = "<leader>s";
                action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
            }

            # Undotree
            {
                mode = "n";
                key = "<leader>u";
                action = "<cmd>UndotreeToggle<CR>";
                options = {
                    silent = true;
                    noremap = true;
                };
            }


            # Fugitive
            {
                mode = "n";
                key = "<leader>gs";
                action = "<cmd>Git<CR>";
                options = {
                    silent = true;
                    noremap = true;
                };
            }

            # NvimTreeToggle
            {
                mode = "n";
                key = "<leader>t";
                action = "<cmd>NvimTreeToggle<CR>";
                options = {
                    silent = true;
                    noremap = true;
                };
            }
            # NvimTreeFindFile
            {
                mode = "n";
                key = "<leader>f";
                action = "<cmd>NvimTreeFindFile<CR>";
                options = {
                    silent = true;
                    noremap = true;
                };
            }

    # ----------------------------------------------------------------

        # Visual mode
            {
                mode = "v";
                key = "<leader>y";
                action = "\"+y";
            }

            {
                mode = "v";
                key = "<leader>d";
                action = "\"_d";
            }
            
            {
                mode = "v";
                key = "J";
                action = ":m '>+1<CR>gv=gv";
            }

            {
                mode = "v";
                key = "K";
                action = ":m '<-2<CR>gv=gv";
            }

            {
                mode = "v";
                key = "<leader>p";
                action = "\"_dP";
            }


        ];

    # ---------------------------------------------------------------------------- #


        # Color scheme
        colorschemes.tokyonight.enable = true;
        
        plugins.lightline.enable = true;

        plugins.indent-blankline.enable = true;

        # File Tree plugin
        plugins.nvim-tree = {
            enable = true;
            disableNetrw = true;
            openOnSetup = true;
            tab.sync.open = true;
            git.ignore = false;
        };

        # Code highlighting and indentation(All grammars enabled by default)
        plugins.treesitter = {
            enable = true;
            folding = false;
            settings = {
                indent.enable = true;
                highlight.enable = true;
            };
        };

        plugins.render-markdown = {
            enable = true;

            settings = {
                render_modes = true;
                signs.enabled = false;
                bullet = {
                    icons = [
                        "◆ "
                        "• "
                        "• "
                    ];
                    right_pad = 1;
                };
                heading = {
                    sign = false;
                    width = "full";
                    position = "inline";
                    border = true;
                    icons = [
                        "1 "
                        "2 "
                        "3 "
                        "4 "
                        "5 "
                        "6 "
                    ];
                };
                code = {
                    sign = false;
                    width = "block";
                    position = "right";
                    language_pad = 2;
                    left_pad = 2;
                    right_pad = 2;
                    border = "thick";
                    above = " ";
                    below = " ";
                };
            };
        };

        # plugins.ts-autotag = {
        #     enable = true;
        #     filetypes = [
        #       "html"
        #       "javascript"
        #       "typescript"
        #       "javascriptreact"
        #       "typescriptreact"
        #       "svelte"
        #       "vue"
        #       "tsx"
        #       "jsx"
        #       "rescript"
        #       "xml"
        #       "php"
        #       "markdown"
        #       "astro"
        #       "glimmer"
        #       "handlebars"
        #       "hbs"
        #     ];
        #     skipTags = [
        #       "area"
        #       "base"
        #       "br"
        #       "col"
        #       "command"
        #       "embed"
        #       "hr"
        #       "img"
        #       "slot"
        #       "input"
        #       "keygen"
        #       "link"
        #       "meta"
        #       "param"
        #       "source"
        #       "track"
        #       "wbr"
        #       "menuitem"
        #     ];
        # };

        # Enables fuzzy finding through treesitter, LSP...
        plugins.telescope = {
            enable = true;

            keymaps = {
                "<leader>ff" = "find_files";
                "<leader>fb" = "buffers";
                "<leader>fg" = "live_grep";
                "<C-p>" = "git_files";

                /*
                This doesnt work because perhaps it should be in some extraConfigLua variable	
                Grep text with telescope in current file
                "<leader>ps" = {
                    action = "function() builtin.grep_string({ search = vim.fn.input(\"Grep > \")}); end";
                };
                */	
            };
        };

        # Telescope extension
        plugins.harpoon = {
            enable = true;

            keymaps = {

                addFile = "<leader>a";
                toggleQuickMenu = "<C-e>";
                navFile = {
                    "1" = "<C-h>";
                    "2" = "<C-t>";
                    "3" = "<C-m>";
                };
            };
        };


        # Git integration
        plugins.fugitive = {
            enable = true;
        };


        # Track change history
        plugins.undotree.enable = true;


        plugins.inc-rename = {
            enable = true;
            settings = {
                cmdName = "IncRename";
                hlGroup = "Substitute";
                previewEmptyName = false;
                showMessage = true;
                inputBufferType = null;
                postHook = null;
            };
        };

        plugins.spectre = {
            enable = true;
        };
        
        # Auto comments
        plugins.comment = {
            enable = true;

            settings.toggler.line = "gcc";
            settings.toggler.block = "gbc";
        };

        # Language Server Protocol
        plugins.efmls-configs.enable = true;
        plugins.lsp = {
            enable = true;

            keymaps = {
                silent = true;
                diagnostic = {
                #	"<leader>k" = "goto_prev"; <--- defined above
                #	"<leader>j" = "goto_next"; <--- defined above
                };

                lspBuf = {
                    "gd" = "definition";
                    "gD" = "references";
                    "gt" = "type_definition";
                    "gi" = "implementation";
                    "K" = "hover";
                };
                
            };

            servers = {
                # eslint.enable = true;
                # html.enable = true;
                # jsonls.enable = true;
                # cssls.enable = true;
                ts_ls.enable = true;
                tailwindcss.enable = true;
                svelte.enable = true;

                gopls.enable = true;
                lua_ls.enable = true;
                nil_ls.enable = true;
                pylsp.enable = true;
                pyright.enable = true;
                ruff.enable = true;
                bashls.enable = true;
                cmake.enable = true;
                clangd.enable = true;
                texlab.enable = true;
                yamlls.enable = true;
                zls.enable = true;
            };
            
        }; 

        # To make use of LSP for rust
        plugins.rustaceanvim.enable = true;

        # Auto-completion
        plugins.luasnip = {
            enable = true;
    # not sure how to setup this snippet lib ---> "rafamadriz/friendly-snippets"
        };

        plugins.lspkind = {
            enable = true;
            mode = "symbol_text";
            preset = "codicons";
            symbolMap = null;
            cmp = {
                enable = true;
                maxWidth = 50;
                ellipsisChar = "...";
                menu = null;
                after = null;
            };
        };

        plugins.cmp = {
            enable = true;
            autoEnableSources = true;

            #snippet.expand = "luasnip";
            #completion = {
            #	keywordLength = 1;
            #};
            # Can define more sources later. see nixvim cmp helper for full list

            settings = {
                # formatting = {
                #     format = ''
                #       require("lspkind").cmp_format({
                #               mode="symbol",
                #               maxwidth = 50,
                #               ellipsis_char = "..."
                #       })
                #     '';
                # };

                snippet = {
                    expand = ''
                      function(args)
                        require("luasnip").lsp_expand(args.body)
                      end
                    '';
                };
                sources = [
                    {name = "path";}
                    {name = "nvim_lsp";}
                    {
                      name = "luasnip";
                      option = {
                        show_autosnippets = true;
                      };
                    }
                    {
                        name = "buffer";
                        option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                    }
                    {name = "neorg";}
                ];

                # Mappings for autocompletion
                mapping = {
                    "<CR>" = "cmp.mapping.confirm({ select = true })";
                    "<C-p>" = "cmp.mapping.select_prev_item(cmp_select)";
                    "<C-n>" = "cmp.mapping.select_next_item(cmp_select)";
                    "<C-Space>" = "cmp.mapping.complete()";
                };
            };
        };



        plugins.trouble = {
            enable = true;
        };

        plugins.web-devicons.enable = true;

        /*
        plugins.coq-nvim = {
            enable = true;
            autoStart = true;
        };
        */

        # Debugging
        #plugins.dap.enable = true;


        # TODO: 
        # Utils: (auto) refactor and indentations
        # Debugging tools like vimspector and codelldb and nvim-DAP
        # FOR DAP: MUST SET A DIFFERENT BRANCH OF nixpkgs AND CONSISTENTLY SET FOR NIXVIM TOO!!!
        # Snippets(rafamadriz/friendly-snippets) - LATER
        };

    in
        flake-utils.lib.eachDefaultSystem (system: let
            pkgs = nixpkgs.legacyPackages.${system};

            goose-nvim-plugin = pkgs.vimUtils.buildVimPlugin {
                pname = "goose.nvim";
                version = "latest";
                src = goose-nvim;
                doCheck = false;
            };

            configWithPlugins = config // {
              extraPlugins = [
                goose-nvim-plugin
              ];
            };

            nvim = nixvim.legacyPackages.${system}.makeNixvim configWithPlugins;
        in {
            packages = {
                inherit nvim;
                default = nvim;
            };
        });

}
