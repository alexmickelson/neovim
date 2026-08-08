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
          nvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
            extraPackages = with pkgs; [
              # Language servers
              gopls
              rust-analyzer
              nodePackages.typescript-language-server
              nixd
              lua-language-server
              pyright

              # Formatters
              stylua
              nodePackages.prettierd
              nodePackages.prettier
              jq
              nixfmt-rfc-style
              rustfmt
              black
              go
            ];
            extraMakeWrapperArgs = ''
              --add-flags "-u ${./init.lua}"
            '';
          };
        in {
          default = nvim;
          neovim = nvim;
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nvim";
        };
      });
    };
}
