let pkgs = import <nixpkgs> {}; in

{

  pbenchSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "pbench";
    rev    = "6d862442713cae93153c439a3e5e5867e95af958";
    sha256 = "1qdsl2amaqkckp2r2s4j5az8b0bpkbrgf8nc0zp575l1yjdzi2hh";
  };

  chunkedseqSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "chunkedseq";
    rev    = "d2925cf385fb43aff7eeb9c08cce88d321e5e02e";
    sha256 = "09qyv48vb2ispl3zrxmvbziwf6vzjh3la7vl115qgmkq67cxv78b";
  };
  
  ligraSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "ligra";
    rev    = "29da629ed7755b7136daf9e73fb810b122c36b42";
    sha256 = "1pkz9c8qxgqnph4yxiqil5g486py8zl9qzi8zmcjwfb40hs7bzrc";
  };

  sc15GraphSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "sc15-pdfs";
    rev    = "3bb37345178fde84ab6cedc92303c36f67059c93";
    sha256 = "11mi049piiv3xn2d5wqrlyxgifjy2k3rc32jyrbl63x4zi1nqp7b";
  };

}
