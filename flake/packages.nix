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
        default = self'.packages.heitor-emacs-pgtk;
        heitor-emacs = pkgs.heitor-emacs;
        heitor-emacs-pgtk = pkgs.heitor-emacs-pgtk;
      };
    };
}
