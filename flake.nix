{
  description = "Utility to access Linux-native filesystems on Windows and macOS";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Build Linsk through: nix build .
      # Build Linsk VM through: ./result/bin/linsk build
      packages.default = pkgs.buildGo121Module rec {
        name = "linsk";
        src = builtins.path {
          path = ./.;
          name = "${name}-src";
        };
        vendorSha256 = "sha256-bZb7ejGxsaQTsW7pF6sPAPrcqqhYntSuyNBXJwOLdzo=";

        nativeBuildInputs = [ pkgs.makeWrapper ];
        postInstall = ''
          wrapProgram $out/bin/linsk --prefix PATH : "${nixpkgs.lib.makeBinPath [ pkgs.qemu ]}"
        '';
      };

      # Enter through: nix develop
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
        ];
        shellHook = ''
          nixpkgs-fmt *.nix;
        '';
      };
    }
  );
}
