{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation {
  name = "lemon-coin";

  src = fetchurl {
    url    = "http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz";
    sha256 = "1j6kp9axhgna47cfnmk1m7vnqn01hwh7pf1fp76aid60yhjwgdvi";
  };

  buildInputs = [ cmake ];
}
