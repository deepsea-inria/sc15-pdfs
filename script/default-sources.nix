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
    rev    = "0178c322bf1325524b22b180ccdb714193a586f4";
    sha256 = "0mfidbsmw1yyj4jj96b8cszxv6wq5wl8dbln3i4i7hw3gvmdm1vq";
  };

}
