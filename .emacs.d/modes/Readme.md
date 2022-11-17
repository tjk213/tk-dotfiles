# Emacs Syntax Highlighting Modes

There is no easy-to-use package manager for these extracurricular syntax modes that I am aware of. So instead, we have to copy them here and check them in manually. This means we have unnecssary code duplication and won't get updates without manually pulling them, but we'll deal with that for now.

### LLVM

[LLVM](https://github.com/llvm/llvm-project/tree/main/llvm/utils/emacs) provides `llvm-mode` and `tablegen-mode` in `llvm-project/llvm/utils/emacs`.

*NOTE*: I haven't checked it out, but github user `nverno` claims to have a better `llvm-mode` solution [here](https://github.com/nverno/llvm-mode).

### MLIR

`mlir-mode` is also provided by the [llvm project](https://github.com/llvm/llvm-project/tree/main/mlir/utils/emacs), this time under `llvm-project/mlir/utils/emacs`.

### Docker

`dockerfile-mode` is courtesy of [spotify](https://github.com/spotify/dockerfile-mode).

### YAML

`yaml-mode` is courtesy of [yoshiki](https://github.com/yoshiki/yaml-mode)
