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

```bash
nix run git+https://github.com/alexmickelson/neovim.git
```
