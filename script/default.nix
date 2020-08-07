{ pkgs   ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  sources ? import ./default-sources.nix,
  hwloc ? pkgs.hwloc,
  numactl ? pkgs.numactl,  
  php ? pkgs.php,
  gcc ? pkgs.gcc,
  pathToResults ? "",
  pathToData ? ""
}:

let

  callPackage = pkgs.lib.callPackageWith (pkgs // sources // self);

  self = {

    hwloc = hwloc;

    gcc = gcc;
    
    chunkedseq = callPackage "${sources.chunkedseqSrc}/script/default.nix" { };

    ligraSrc = sources.ligraSrc;
    sc15GraphSrc = sources.sc15GraphSrc;

    graphBench = import ./bench-script.nix { sources = sources; };
    
  };

in

with self;

stdenv.mkDerivation rec {
  name = "sc15-graph";

  src = sc15GraphSrc;

  buildInputs =
    [ chunkedseq ligraSrc pkgs.bash
      pkgs.makeWrapper pkgs.R pkgs.texlive.combined.scheme-small
      pkgs.ocaml gcc php
    ];

  configurePhase =
    let hwlocConfig =
      ''
        USE_HWLOC=1
        CUSTOM_HWLOC_PARAMS=-I ${hwloc.dev}/include/ -L ${hwloc.lib}/lib/ -lhwloc
      '';
    in
    let settingsScript = pkgs.writeText "settings.sh" ''
      CHUNKEDSEQ_PATH=${chunkedseq}/include/
      ${hwlocConfig}    
    '';
    in
    ''
    cp ${settingsScript} sc15-graph/graph/bench/settings.sh
    '';

  buildPhase =
    let getNbCoresScript = pkgs.writeScript "get-nb-cores.sh" ''
      #!/usr/bin/env bash
      nb_cores=$( ${hwloc}/bin/hwloc-ls --only core | wc -l )
      echo $nb_cores
    '';
    in
    ''
    export PATH=${php}/bin:$PATH
    pushd sc15-graph/graph/bench
    cp ${getNbCoresScript} ./get-nb-cores.sh
    bash ./get-nb-cores.sh > nb_cores
    make search.all_opt2 
    make search.opt2 search.elision2 graphfile.elision2
    popd
    '';  

  installPhase =
    let hw =
        ''--prefix LD_LIBRARY_PATH ":" ${hwloc.lib}/lib'';
    in
    let nmf = "-skip make";
    in
    let rf =
      if pathToResults != "" then
        "-path_to_results ${pathToResults}"
      else "";
    in
    let df =
      if pathToData != "" then
        "-path_to_data ${pathToData}"
      else "";
    in
    let nc = "-path_to_nb_cores $out/bench/nb_cores"; in
    let flags = "${nmf} ${rf} ${df} ${nc}";
    in
    ''
    mkdir -p $out/bench/
    cp sc15-graph/graph/bench/nb_cores $out/bench
    cp sc15-graph/graph/bench/search.all_opt2 $out/bench
    cp sc15-graph/graph/bench/search.virtual  $out/bench
    cp sc15-graph/graph/bench/search.opt2  $out/bench
    cp sc15-graph/graph/bench/search.elision2 $out/bench
    cp sc15-graph/graph/bench/graphfile.elision2 $out/bench
    cp ${graphBench}/graph $out/bench/graph.pbench
    wrapProgram $out/bench/graph.pbench --prefix PATH ":" ${pkgs.R}/bin \
       --prefix PATH ":" ${pkgs.texlive.combined.scheme-small}/bin \
       --prefix PATH ":" ${gcc}/bin \
       --prefix PATH ":" ${php}/bin \
       --prefix PATH ":" ${numactl}/bin \
       --prefix PATH ":" ${pkgs.ipget}/bin \
       --prefix PATH ":" $out/bench \
       --prefix LD_LIBRARY_PATH ":" ${gcc}/lib \
       --prefix LD_LIBRARY_PATH ":" ${gcc}/lib64 \
       ${hw} \
       --add-flags "${flags}"
    wrapProgram $out/bench/search.all_opt2 --prefix PATH ":" ${gcc}/bin \
       --prefix PATH ":" ${numactl}/bin \
       --prefix LD_LIBRARY_PATH ":" ${gcc}/lib \
       --prefix LD_LIBRARY_PATH ":" ${gcc}/lib64
    '';

  meta = {
    description = "";
    license = "MIT";
    homepage = http://deepsea.inria.fr/graph/;
  };
}
