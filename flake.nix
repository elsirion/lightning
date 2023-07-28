{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, crane, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        craneLib = crane.lib.${system};
	pkgs = import nixpkgs {
          inherit system;
        };
      in
    {
      packages.default = craneLib.buildPackage {
        src = ./.;
        pname = "cln-grpc";
        version = "0.1.0";
        
        buildInputs = [ pkgs.openssl ];
        nativeBuildInputs = [ pkgs.pkg-config pkgs.perl pkgs.protobuf pkgs.rustfmt ];
      };
    });
}
