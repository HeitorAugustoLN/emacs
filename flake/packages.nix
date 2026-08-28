{ inputs, self, ... }: {
  perSystem =
    {
      pkgs,
      self',
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };

      packages = {
        default = self'.packages.emacs-pgtk-wrapped;
        emacs-pgtk-wrapped = pkgs.emacs-pgtk-wrapped;
      };
    };
}
