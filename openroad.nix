{ stdenv, lib, fetchFromGitHub
, cmake, swig, boost, python3, tcl, zlib, spdlog, bison, flex
, eigen, lemon-coin, doxygen, readline
}:

let
  rev = "79a46b62da64bbebc18f06b20c42211046de719a";
  sha256 = "0pjhwav7s6x0sc1apcfy4wvs005b2yqf7hpva03iinxjnlkpvr9g";
in

stdenv.mkDerivation {
  name = "openroad";

  src = fetchFromGitHub {
    owner  = "The-OpenROAD-Project";
    repo   = "OpenROAD";
    inherit rev sha256;
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DOPENROAD_VERSION=${rev}"
    "-DUSE_SYSTEM_BOOST=ON"
    #"-DUSE_SYSTEM_ABC=ON"
    #"-DABC_LIBRARY=${abc-verifier}/lib/libabc.a"
    #"-DABC_INCLUDE_DIR=${abc-verifier}/include/abc"
  ];

  postConfigure = ''
    patchShebangs ../etc
  '';

  buildInputs = [
    cmake swig boost python3 tcl zlib spdlog bison flex
    eigen lemon-coin doxygen readline
  ];
}
