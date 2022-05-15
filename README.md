# zerotoasic-nix

To use this, first install [Nix](https://nixos.org/download.html). Either follow
the `sh <(curl ...)` instructions there, or install it with your distribution
package manager (e.g.: `sudo apt install nix`).
There are more instructions on installing Nix in the
[manual](https://nixos.org/manual/nix/stable/installation/installing-binary.html).

This repo has only been tested on Linux.

## Simple use

Once Nix is installed, you can enter a shell that has OpenROAD, Magic, KLayout,
and various Verilog tools available by running `nix-shell -A chipShell`.

You can also enter a shell that contains a complete RISC-V toolchain by running
`nix-shell -A riscShell`. Inside this shell, commands like `gcc` or `ld` will
generate / work on RV32 executables.

The first time you run either of these commands you may have to wait a while as
some packages are not available in the Nix binary cache and so must be built
from source.

## Advanced use

If you want to ensure that your shell does not contain executables available
from your system (i.e.: for debugging), you can add the `--pure` flag.
For example, if you do `nix-shell -A riscShell --pure`, you can build a project
while ensuring that no libraries from your system are accidentally being linked
in.

If you want additional dependencies available to your RISC-V build environment,
you can add them to the `buildInputs = [];` list under `riscShell` in
`default.nix`. Packages added to that list will be cross-compiled to RISC-V.
For native dependencies (e.g.: build tools), add them to the
`nativeBuildInputs = [];` list.

For example, if you wanted `sqlite` available as a build dependency, and you
wanted `m4` as a native dependency, it would look like

```
  riscShell = riscvPkgs.stdenv.mkDerivation {
    name = "zerotoasic-riscv";
    buildInputs = [
      riscvPkgs.sqlite
    ];
    nativeBuildInputs = [
      pkgs.m4
    ];
  };
```

If you want to explore the structure of the packages exposed here, you can run
`nix-repl default.nix`. TAB-completion will show available names in scope.
Children of an "attribute set" (the Nix concept similar to a JSON object) can
be accessed with the `.` operator, similar to many other languages, and TAB
completion works on those children too.
