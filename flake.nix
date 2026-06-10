{
  description = "Dusklight";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      version = "1.3.1";

      pkgs = import nixpkgs { inherit system; };

      src = pkgs.fetchurl {
        url = "https://github.com/TwilitRealm/dusklight/releases/download/v${version}/Dusklight-v${version}-linux-x86_64.AppImage";
        hash = "sha256-RuNtxQ+24W3ZVT/1v6Z5Qq3peZSAelLu+8hEObmuIo8=";
      };

      extracted = pkgs.appimageTools.extract {
        pname = "dusklight";
        inherit version src;
      };

      dusklight = pkgs.appimageTools.wrapType2 {
        pname = "dusklight";
        inherit version src;
        extraInstallCommands = ''
          install -Dm644 ${extracted}/dev.twilitrealm.dusk.desktop $out/share/applications/dusklight.desktop
          cp -r ${extracted}/usr/share/icons $out/share/icons
        '';
      };
    in
    {
      packages."${system}" = {
        dusklight = dusklight;
        default = dusklight;
      };

      apps."${system}".default = {
        type = "app";
        program = "${dusklight}/bin/dusklight";
      };
    };
}
