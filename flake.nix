{
  description = "MiniPc from work";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
    }:
    {
      nixosConfigurations.nixos-lobo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.carlos = import ./home.nix;
          }

          {
            nixpkgs.overlays = [
              (final: prev: {
                bruno = nixpkgs-unstable.legacyPackages.${final.system}.bruno;
                gemini-cli = nixpkgs-unstable.legacyPackages.${final.system}.gemini-cli;

                prettier-plugin-svelte = final.buildNpmPackage rec {
                  pname = "prettier-plugin-svelte";
                  version = "3.4.1";

                  src = final.fetchFromGitHub {
                    owner = "sveltejs";
                    repo = "prettier-plugin-svelte";
                    rev = "v${version}";
                    hash = "sha256-K6NJELgNVs5/hBDps2KHizm/Hk5MKAyRcqTqg/L/gKY=";
                  };
                  npmDepsHash = "sha256-zJf4gQmd38RUD91XcpymACY5Z7WAk1LFbdo7QCIgYvs=";
                  # Sometimes tests fail in sandbox, so we disable them for simple plugins
                  dontNpmBuild = true;
                };

                svelte = final.stdenv.mkDerivation rec {
                  pname = "svelte";
                  version = "5.1.0";
                  src = final.fetchurl {
                    url = "https://registry.npmjs.org/svelte/-/svelte-${version}.tgz";
                    hash = "sha256-N3uwelON+yPHHgHdZ4De3j2wJdaB1ouA4SlGodRW5tE=";
                  };
                  dontBuild = true;
                  installPhase = ''
                    mkdir -p $out/lib/node_modules/svelte
                    cp -r . $out/lib/node_modules/svelte
                  '';
                };
              })
            ];
          }
        ];
      };
    };
}
