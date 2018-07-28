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

    pbench = callPackage "${sources.pbenchSrc}/script/default.nix" { };
    chunkedseq = callPackage "${sources.chunkedseqSrc}/script/default.nix" { };

    ligraSrc = sources.ligraSrc;
    sc15GraphSrc = sources.sc15GraphSrc;
    
  };

in

with self;

stdenv.mkDerivation rec {
  name = "sc15-graph";

  src = sc15GraphSrc;

  buildInputs =
    [ pbench chunkedseq ligraSrc pkgs.bash
      pkgs.makeWrapper pkgs.R pkgs.texlive.combined.scheme-small
      pkgs.ocaml gcc
    ];

  configurePhase =
    let hwlocConfig =
      ''
        USE_HWLOC=1
        CUSTOM_HWLOC_PARAMS=-I ${hwloc.dev}/include/ -L ${hwloc.lib}/lib/ -lhwloc
      '';
    in
    let settingsScript = pkgs.writeText "settings.sh" ''
      PBENCH_PATH=../../../pbench/
      CHUNKEDSEQ_PATH=${chunkedseq}/include/
      ${hwlocConfig}    
    '';
    in
    ''
    cp -r --no-preserve=mode ${pbench} pbench
    cp -r --no-preserve=mode ${ligraSrc} ligra
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
    cp ${getNbCoresScript} sc15-graph/graph/bench/get-nb-cores.sh
    export PATH=${php}/bin:$PATH
    make -C sc15-graph/graph/bench graph.pbench
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
    cp sc15-graph/graph/bench/graph.pbench sc15-graph/graph/bench/timeout.out $out/bench/
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
    pushd sc15-graph/graph/bench
    $out/bench/graph.pbench generate -only make -proc 1
    $out/bench/graph.pbench baselines -only make -proc 1
    $out/bench/graph.pbench overview -only make -proc 1
    make search.all_opt2
    ./get-nb-cores.sh > $out/bench/nb_cores
    cp search.virtual search.opt2 search.elision2 graphfile.elision2 search.all_opt2 $out/bench
    popd
    wrapProgram $out/bench/search.all_opt2 --prefix PATH ":" ${gcc}/bin \
       --prefix PATH ":" ${numactl}/bin \
       --prefix LD_LIBRARY_PATH ":" ${gcc}/lib \
       --prefix LD_LIBRARY_PATH ":" ${gcc}/lib64
    cp ligra/ligra.cilk_* $out/bench
    '';

  meta = {
    description = "";
    license = "MIT";
    homepage = http://deepsea.inria.fr/graph/;
  };
}
