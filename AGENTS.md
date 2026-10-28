When the user asks for ideas or recommendations, give ideas first; do not change files unless they ask for implementation.

## Temporary Neovim checks

For behavior that depends on the loaded configuration or plugins, write a small Lua script under `/tmp` and run Neovim headlessly with this repository's `init.lua`. Keep test files and any generated state outside the repository.

```sh
XDG_STATE_HOME=/tmp/nvim-check-state XDG_CACHE_HOME=/tmp/nvim-check-cache \
  nvim --headless -i NONE -u init.lua \
  '+lua local ok, err = xpcall(function() dofile("/tmp/nvim-check.lua") end, debug.traceback); if not ok then io.stderr:write(err .. "\n"); vim.cmd("cquit 1") end' \
  +qa!
```

In the script, create the starting editor state, perform the interaction through the same command, mapping, or plugin API a user would use, and assert observable results. Check buffers, windows, tabs, options, or plugin state with `vim.api` and `assert(condition, "clear failure message")`. If the interaction is asynchronous, use `vim.wait(timeout_ms, condition)` and assert that it returned true. Test both the expected result and any state that should have been cleaned up.

The `xpcall` wrapper prints a traceback and exits with a nonzero status on failure; a plain `+luafile` error can otherwise be easy to miss in a shell check. Keep each script focused, remove temporary artifacts when done, and state which interaction was exercised if the check bypassed part of the user-facing path.
