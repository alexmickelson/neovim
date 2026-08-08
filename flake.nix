{
  description = "Neovim with this configuration's LSPs and formatters";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          tools = with pkgs; [
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

            ansible-language-server
            ansible
            ansible-lint
            yamlfmt

            jq
          ];
          nvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
            extraPackages = tools;
            extraMakeWrapperArgs = ''
              --add-flags "-u ${./init.lua}"
            '';
          };
        in {
          default = nvim;
          neovim = nvim;
          tools = pkgs.buildEnv {
            name = "neovim-dev-tools";
            paths = tools;
          };
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      });
    };
}
