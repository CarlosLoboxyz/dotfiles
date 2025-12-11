{
  description = "Workstation laptop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
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
      nixos-hardware,
      home-manager,
    }@inputs:
    {
      nixosConfigurations.chicot = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t480
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.carlos = import ./home.nix;
          }

          # Overlays to use packages from the unstable branch
          {
            nixpkgs.overlays = [
              (final: prev: {
                bruno = nixpkgs-unstable.legacyPackages.${final.system}.bruno;
                zed-editor = nixpkgs-unstable.legacyPackages.${final.system}.zed-editor;
              })
            ];
          }
        ];
      };
    };
}
