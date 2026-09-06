{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.overlays.default =
    let
      inherit (lib.fixedPoints) composeManyExtensions;
    in
    composeManyExtensions [
      inputs.emacs-overlay.overlays.default
      (
        final: prev:
        let
          wrappedEmacsFor =
            emacs:
            final.callPackage (
              { emacs }:
              emacs.pkgs.withPackages (emacsPackages: [
                # Placed first so `lndir` creates the site-lisp symlink from this package before
                # heitor-emacs-configuration can claim the file.
                emacsPackages.heitor-emacs-directory
                emacsPackages.heitor-emacs-configuration
              ])
            ) { inherit emacs; };
        in
        {
          heitor-emacs = wrappedEmacsFor final.emacs;
          heitor-emacs-pgtk = wrappedEmacsFor final.emacs-pgtk;

          emacsPackagesFor =
            emacs:
            (prev.emacsPackagesFor emacs).overrideScope (
              efinal: eprev:
              let
                emacsDirectory = builtins.path {
                  name = "heitor-emacs-directory-source";
                  path = ../emacs;
                };

                # MELPA format: YYYYMMDD.HHMM
                version =
                  let
                    inherit (builtins) substring;
                    lastModifiedDate = self.lastModifiedDate or "19700101000000";
                  in
                  "${substring 0 8 lastModifiedDate}.${substring 8 4 lastModifiedDate}";

                meta = {
                  homepage = "https://github.com/HeitorAugustoLN/emacs";
                  license = lib.licenses.mit;
                  maintainers = [ lib.maintainers.HeitorAugustoLN ];
                };
              in
              {
                heitor-emacs-configuration = efinal.callPackage (
                  {
                    lib,
                    trivialBuild,
                    linkFarm,
                  }:
                  let
                    pname = "heitor-emacs-configuration";
                  in
                  trivialBuild {
                    inherit pname version;

                    src =
                      let
                        inherit (builtins) filter;
                        inherit (lib.filesystem) listFilesRecursive;
                        inherit (lib.strings) hasSuffix unsafeDiscardStringContext;
                        inherit (lib.trivial) pipe;
                      in
                      pipe emacsDirectory [
                        listFilesRecursive
                        (filter (hasSuffix ".el"))
                        (map (
                          file:
                          let
                            fileName = pipe file [
                              unsafeDiscardStringContext
                              baseNameOf
                            ];
                          in
                          {
                            name =
                              {
                                "init.el" = "default.el";
                                "early-init.el" = "early-default.el";
                              }
                              .${fileName} or fileName;

                            path = file;
                          }
                        ))
                        (linkFarm "heitor-emacs-configuration-source")
                      ];

                    postBuild = ''
                      emacs --batch --eval "(progn (require 'package) (package-generate-autoloads \"${pname}\" \".\"))"
                    '';

                    meta = meta // {
                      description = "Heitor's Emacs configuration files, packaged as an Emacs package";
                    };
                  }
                ) { };

                heitor-emacs-directory = efinal.callPackage (
                  { trivialBuild, writeText }:
                  trivialBuild {
                    pname = "heitor-emacs-directory";
                    inherit version;

                    src = writeText "heitor-emacs-directory.el" ''
                      ;;; heitor-emacs-directory.el --- Heitor's Emacs configuration directory -*- lexical-binding: t; -*-

                      ;;; Code:

                      (defconst heitor-emacs-directory "${emacsDirectory}/"
                        "Directory containing Heitor's Emacs configuration files.")

                      (provide 'heitor-emacs-directory)

                      ;;; heitor-emacs-directory.el ends here
                    '';

                    meta = meta // {
                      description = "Emacs package providing the directory of Heitor's Emacs configuration files";
                    };
                  }
                ) { };
              }
            );
        }
      )
    ];
}
