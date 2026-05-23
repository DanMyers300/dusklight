{
  description = "Dusklight";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      version = "1.2.0";

      pkgs = import nixpkgs { inherit system; };

      src = pkgs.fetchurl {
        url = "https://github.com/TwilitRealm/dusklight/releases/download/v${version}/Dusklight-v${version}-linux-x86_64.AppImage";
        hash = "sha256-CChoFnLwy6VCGPJtktBvwN1+PpTiSmQ1ka2Wycd2NX4=";
      };

      extracted = pkgs.appimageTools.extract {
        pname = "dusklight";
        inherit version src;
      };

      dusklight = pkgs.appimageTools.wrapType2 {
        pname = "dusklight";
        inherit version src;
        extraInstallCommands = ''
          install -Dm644 ${extracted}/dusklight.desktop $out/share/applications/dusklight.desktop
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
