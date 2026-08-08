# neovim

Consume this configuration from another flake:

```bash
inputs.neovim.url = "git+https://git.alexmickelson.guru/alex/neovim.git";
```

Install Neovim and make the language servers and formatters available as shell commands:

```nix
environment.systemPackages = [
  inputs.neovim.packages.${pkgs.system}.default
  inputs.neovim.packages.${pkgs.system}.tools
];
```

For a development shell, add the tools package to `packages` instead:

```nix
devShells.${pkgs.system}.default = pkgs.mkShell {
  packages = [ inputs.neovim.packages.${pkgs.system}.tools ];
};
```

```bash
nix run git+https://github.com/alexmickelson/neovim.git
```
