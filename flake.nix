{
  description = "Utility to access Linux-native filesystems on Windows and macOS";

  # TODO: Rewrite to use flake-utils
  # Currently this was a quick-and-dirty writeup for x86_64-darwin but
  # aarch64-darwin will be needed for the M2 MBA that I bought a few days back.
  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-darwin;
    in
    {
      # Build through: nix build .
      packages.x86_64-darwin.default = pkgs.buildGo121Module rec {
        name = "linsk";
        src = builtins.path {
          path = ./.;
          name = "${name}-src";
        };
        vendorSha256 = "sha256-bZb7ejGxsaQTsW7pF6sPAPrcqqhYntSuyNBXJwOLdzo=";

        nativeBuildInputs = [ ];
      };

      # Enter through: nix develop
      devShells.x86_64-darwin.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
        ];
        shellHook = ''
          nixpkgs-fmt *.nix;
        '';
      };
    };
}
