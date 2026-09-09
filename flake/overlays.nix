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
            (final.callPackage (
              { emacs }:
              emacs.pkgs.withPackages (emacsPackages: [
                # Placed first so `lndir` creates the site-lisp symlink from this package before
                # heitor-emacs-configuration can claim the file.
                emacsPackages.heitor-emacs-directory
                emacsPackages.heitor-emacs-configuration
              ])
            ) { inherit emacs; }).overrideAttrs
              (oldAttrs: {
                passthru = oldAttrs.passthru or { } // {
                  inherit (emacs) pkgs;
                };
              });
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

                    # Emacs packages
                    corfu,
                    ef-themes,
                    fontaine,
                    ghostel,
                    marginalia,
                    move-text,
                    nix-mode,
                    nix-ts-mode,
                    orderless,
                    vertico,

                    # External dependencies (LSPs, tree-sitter grammars, etc.)
                    marksman,
                    nixd,
                    treesit-grammars,
                  }:
                  trivialBuild (finalAttrs: {
                    pname = "heitor-emacs-configuration";
                    inherit version;

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
                      emacs --batch --eval "(progn (require 'package) (package-generate-autoloads \"${finalAttrs.pname}\" \".\"))"
                    '';

                    packageRequires =
                      let
                        dependencies = {
                          emacs = {
                            packages = [
                              corfu
                              ef-themes
                              fontaine
                              ghostel
                              marginalia
                              move-text
                              orderless
                              vertico
                            ];

                            modes.nix = [
                              nix-mode
                              nix-ts-mode
                            ];
                          };

                          external = {
                            languageServers = {
                              nix = nixd;
                              markdown = marksman;
                            };

                            treesitterGrammars = treesit-grammars.with-grammars (grammars: [
                              grammars.tree-sitter-nix
                              grammars.tree-sitter-markdown
                              grammars.tree-sitter-markdown-inline
                            ]);
                          };
                        };
                      in
                      let
                        isDependency =
                          let
                            anyPredicate = preds: value: builtins.any (pred: pred value) preds;
                            allPredicates = preds: value: builtins.all (pred: pred value) preds;
                          in
                          anyPredicate [
                            lib.isDerivation
                            (allPredicates [
                              lib.isList
                              (lib.all lib.isDerivation)
                            ])
                          ];
                      in
                      lib.pipe dependencies [
                        (lib.collect isDependency)
                        lib.flatten
                      ];

                    meta = meta // {
                      description = "Heitor's Emacs configuration, packaged as an Emacs package";
                    };
                  })
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
                      description = "Emacs package providing the directory constant for Heitor's Emacs configuration";
                    };
                  }
                ) { };
              }
            );
        }
      )
    ];
}
