# Keyboard firmware

Reproducible ZSA Voyager QMK firmware build and explicit Zapp flash command.

```console
nix build
nix run .#flash
```

Edit `voyager/keymap.c`, `voyager/config.h`, and `voyager/rules.mk`. The build copies them into the pinned ZSA QMK tree as the `dots` keymap. `voyager/keymap.json` enables ZSA default modules.

Flash remains an explicit operation. Do not run it during NixOS or Home Manager activation.
