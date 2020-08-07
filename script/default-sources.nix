let pkgs = import <nixpkgs> {}; in

let   pbenchSrc = pkgs.fetchFromGitHub {
      owner  = "mikerainey";
      repo   = "pbench";
      rev    = "1c90259b594b6612bc6b9973564e89c297ad17b3";
      sha256 = "1440zavl3v74hcyg49h026vghhj1rv5lhfsb5rgfzmndfynzz7z0";
  };
in

let   sc15GraphSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "sc15-pdfs";
    rev    = "1e4cb218b0ddb72d2f6665683d08401baff05d37";
    sha256 = "1wbzz5l611wb21j9q7g1w1akildvn6ima6zszfqsnv79r4xp8wpc";
  };
in

let
  nixSrc = "${sc15GraphSrc}/script";
in

{

  nixSrc = nixSrc;

  cmdlineSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "cmdline";
    rev    = "c5f96b4aecb2019b5a690176195d37f7df3ed34b";
    sha256 = "1rz9bfdd5242gy3vq4n9vj2rcr5pwp0j4cjycpn3pm7rnwrrcjnh";
  };

  pbenchOcamlSrcs = import "${pbenchSrc}/nix/local-sources.nix";
  
  chunkedseqSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "chunkedseq";
    rev    = "2c54d8f289b75397e783ebf3a91e3881924c6a39";
    sha256 = "08bx2i63bmawm6qz1kr9f8pj3ccl7ccpg9vhzb38bma7zv530dn3";
  };
  
  ligraSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "ligra";
    rev    = "29da629ed7755b7136daf9e73fb810b122c36b42";
    sha256 = "1pkz9c8qxgqnph4yxiqil5g486py8zl9qzi8zmcjwfb40hs7bzrc";
  };

  sc15GraphSrc = sc15GraphSrc;
  benchOcamlSrc = "${sc15GraphSrc}/sc15-graph/graph/bench/";
}
