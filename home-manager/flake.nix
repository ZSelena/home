{
  description = "Home Manager configuration of sele";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
	  stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		nvf = {
			url = "github:NotAShelf/nvf";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    mango = {
      url = "github:ernestoCruz05/mango-ext";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs =
    { nixpkgs, home-manager, stylix, nvf, mango, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."sele" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
		  ./home.nix
		      stylix.homeModules.stylix
					nvf.homeManagerModules.default
          mango.hmModules.mango
				];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
		extraSpecialArgs = {
		  inherit inputs;
		};
	};
	nixpkgs.config = {
	  allowUnfree = true;
	  allowUnfreePredicate = (_: true);
	};
    };
}
