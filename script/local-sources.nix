let pkgs = import <nixpkgs> {}; in

{

  pbenchSrc = ../../pbench;

  chunkedseqSrc = ../../chunkedseq;

  ligraSrc = ../../ligra;

  sc15GraphSrc = ../.;

}
