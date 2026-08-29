{
  description = "lapstrop's nixos configuration";

  #========  INPUTS
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    #========  APPS
    # areofyl-fetch
    areofyl-fetch = {
      url = "github:areofyl/fetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # kde plasma manager
    #plasma-manager = {
    #url = "github:nix-community/plasma-manager";
    #inputs.nixpkgs.follows = "nixpkgs";
    #inputs.home-manager.follows = "home-manager";
    #};

    #========  HOME MANAGER
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #========  OUTPUTS
  outputs =
    {
      self,
      nixpkgs,
      areofyl-fetch,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.lapstrop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          #========  APPS
          # areofyl-fetch
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              areofyl-fetch.overlays.default
            ];
            environment.systemPackages = [
              areofyl-fetch.packages.${pkgs.system}.default
            ];
          })

          { nix.registry.nixpkgs.flake = nixpkgs; }

          #========  HOME MANAGER MODULES
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lapstrop = import ./home_manager.nix;
          }
        ];
      };
    };
}
