rec {
  overlay = self: super: {
    #lemon-coin = self.callPackage ./lemon.nix {};
    # abc-verifier = super.abc-verifier.overrideAttrs (old: {
    #   src = super.fetchFromGitHub {
    #     owner  = "The-OpenROAD-Project";
    #     repo   = "abc";
    #     rev    = "59ead256fc8cf9900b0d44a6173984cb1f8e6ded";
    #     sha256 = "0k2802134d0x342l2zp2bz1k2pp7c5fv7ma7wf4ddpp7h0h3i77v";
    #   };
    #   nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
    #     super.findutils
    #     super.gnugrep
    #   ];
    #   installPhase = ''
    #     mkdir -pv $out/bin $out/lib $out/include
    #     mv -v abc $out/bin
    #     mv -v libabc.a $out/lib
    #     mv -v ../src $out/include/abc
    #     find $out/include -type f | grep -v '[.]h$' | xargs rm
    #     # Repeat a few times to remove empty directory trees of a given depth
    #     find $out/include -empty -type d -delete
    #     find $out/include -empty -type d -delete
    #     find $out/include -empty -type d -delete
    #     find $out/include -empty -type d -delete
    #     find $out/include -empty -type d -delete
    #   '';
    #   enableParallelBuilding = true;
    # });
    #openroad = self.callPackage ./openroad.nix {};

    openroad = super.openroad.overrideAttrs (old: {
       version = "2.1rc";
       src = super.fetchFromGitHub {
         owner  = "The-OpenROAD-Project";
         repo   = "OpenROAD";
         rev    = "63139a5d7b15d6a6818853be33254eb0a651cad8";
         sha256 = "1gffnjgjlrkd92a6y1i741ah3ia8n389q42bnbci123p37dhdg12";
         fetchSubmodules = true;
       };
       cmakeFlags = (old.cmakeFlags or []) ++ [
         "-DOPENROAD_VERSION=2.1rc-github-head"
         "-DUSE_SYSTEM_BOOST=ON"
       ];
    });
  };

  nixpkgsRev = "41ff747f882914c1f8c233207ce280ac9d0c867f";
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgsRev}.tar.gz";
    sha256 = "1przm11d802bdrhxwsa620af9574fiqsl44yhqfci0arf5qsadij";
  };
  pkgs = import nixpkgs {
    config = {};
    overlays = [overlay];
  };
  riscvPkgs = pkgs.pkgsCross.riscv32;

  chipShell = pkgs.mkShell {
    packages = [
      pkgs.openroad
      pkgs.magic-vlsi
      pkgs.ngspice
      pkgs.klayout
      (pkgs.python3.withPackages (p: [p.cocotb]))

      pkgs.symbiyosys
      pkgs.boolector
      pkgs.z3
      pkgs.yices
      pkgs.avy
      pkgs.bitwuzla
      pkgs.aiger
      pkgs.mcy
      pkgs.abc-verifier

      pkgs.nextpnr
      pkgs.icestorm
      pkgs.trellis
      pkgs.openfpgaloader
      pkgs.dfu-util
      pkgs.ecpdap
      pkgs.fujprog
      pkgs.openocd

      pkgs.gtkwave
      pkgs.verilator
      pkgs.verilog
    ];
  };

  riscShell = riscvPkgs.stdenv.mkDerivation {
    name = "zerotoasic-riscv";
    buildInputs = [];
    nativeBuildInputs = [];
  };
}
