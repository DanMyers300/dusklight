{
  description = "Dusklight";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      version = "1.1.1";

      pkgs = import nixpkgs { inherit system; };

      dusklight = pkgs.appimageTools.wrapType2 {
        pname = "dusklight";
        inherit version;
        src = pkgs.fetchurl {
          url = "https://github.com/TwilitRealm/dusklight/releases/download/v${version}/Dusklight-v${version}-linux-x86_64.AppImage";
          hash = "sha256-8BtK1XZGHxw2EbbgymV86gvnYPYO6fiZYQdueRs8oWM=";
        };
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
