{
  description = "Java development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs}: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = with pkgs; [
        nodejs_23
      ];

      shellHook = ''
        # initialize git repo, if missing
        if [ ! -d .git ]; then
          echo "Initializing git repository..."
          git init
        fi

        # set zsh
        exec zsh
      '';
    };
  };
}
