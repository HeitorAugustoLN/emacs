{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    programs = {
      nixf-diagnose = {
        enable = true;
        priority = -1;
      };

      nixfmt = {
        enable = true;
        strict = true;
      };
    };
  };
}
