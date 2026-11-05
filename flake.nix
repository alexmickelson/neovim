{
  description = "Neovim with this configuration's LSPs and formatters";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          tools = with pkgs; [
            git
            nerd-fonts.fira-code
            gopls
            go

            rust-analyzer
            rustfmt

            typescript-language-server
            prettierd
            prettier

            nixd
            nixfmt

            lua-language-server
            stylua

            pyright
            black

            # ansible-language-server
            # ansible
            # ansible-lint
            yamlfmt

            jq

            bash-language-server
            shellcheck
            shfmt
          ];
          treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
            parsers: with parsers; [
              bash
              c
              diff
              go
              html
              javascript
              json
              lua
              luadoc
              markdown
              markdown_inline
              nix
              python
              query
              rust
              tsx
              typescript
              vim
              vimdoc
              yaml
            ]
          );
          plugins = with pkgs.vimPlugins; [
            guess-indent-nvim
            gitsigns-nvim
            which-key-nvim
            tokyonight-nvim
            todo-comments-nvim
            nvim-highlight-colors
            mini-nvim
            snacks-nvim
            nvim-web-devicons

            plenary-nvim
            telescope-nvim
            telescope-ui-select-nvim
            telescope-fzf-native-nvim

            fidget-nvim
            nvim-lspconfig
            conform-nvim
            luasnip
            blink-cmp
            nvim-tree-lua
            toggleterm-nvim
            diffview-nvim
            multicursor-nvim
          ];
          mkNeovim =
            { followSystemStyle ? false }:
            pkgs.wrapNeovim pkgs.neovim-unwrapped {
              extraPackages = tools;
              configure.packages.main.start = [ treesitter ] ++ plugins;
              extraMakeWrapperArgs = nixpkgs.lib.concatStringsSep " " (
                nixpkgs.lib.optionals followSystemStyle [ "--set NVIM_FOLLOW_SYSTEM_STYLE 1" ]
                ++ [
                  "--set NVIM_COLORS_LUA ${./colors.lua}"
                  ''--add-flags "-u ${./init.lua}"''
                ]
              );
            };
          nvim = mkNeovim { };
          nvimFollowSystemStyle = mkNeovim { followSystemStyle = true; };
        in
        {
          default = nvim;
          neovim = nvim;
          follow-system-style = nvimFollowSystemStyle;
          tools = pkgs.buildEnv {
            name = "neovim-dev-tools";
            paths = tools;
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      });
    };
}
