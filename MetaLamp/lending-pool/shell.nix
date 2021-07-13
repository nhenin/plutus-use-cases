let
  packages = import ./.;
  inherit (packages) pkgs plutus-starter;
  inherit (plutus-starter) haskell;

in
  haskell.project.shellFor {
    withHoogle = false;

    nativeBuildInputs = with plutus-starter; [
      hlint
      cabal-install
      purs
      spago
      haskell-language-server
      stylish-haskell
      pkgs.niv
      cardano-repo-tool
    ];
  }
