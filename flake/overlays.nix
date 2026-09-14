{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.overlays.default = lib.fixedPoints.composeManyExtensions [
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
                  gnome-dark-style,
                  marginalia,
                  multiple-cursors,
                  move-text,
                  nix-mode,
                  nix-ts-mode,
                  orderless,
                  treesit-auto,
                  vertico,

                  # External dependencies (LSPs, formatters, fonts, treesitter grammars, etc.)
                  marksman,
                  nixd,
                  nixfmt,
                  treesit-grammars,
                  geist-font,
                }:
                let
                  inherit (lib.trivial) pipe;
                in
                trivialBuild (finalAttrs: {
                  pname = "heitor-emacs-configuration";
                  inherit version;

                  src = pipe emacsDirectory [
                    lib.filesystem.listFilesRecursive
                    (builtins.filter (lib.strings.hasSuffix ".el"))
                    (map (
                      file:
                      let
                        fileName = pipe file [
                          builtins.unsafeDiscardStringContext
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
                    emacs --batch --eval "
                      (progn
                        (require 'package)
                        (package-generate-autoloads \"${finalAttrs.pname}\" \".\"))"
                  '';

                  packageRequires =
                    let
                      dependencies = {
                        fonts = [ geist-font ];

                        emacsPackages = [
                          corfu
                          ef-themes
                          fontaine
                          ghostel
                          gnome-dark-style
                          marginalia
                          multiple-cursors
                          move-text
                          nix-mode
                          nix-ts-mode
                          orderless
                          treesit-auto
                          vertico
                        ];

                        external = {
                          formatters = {
                            nix = nixfmt;
                          };

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
                          inherit (lib.attrsets) isDerivation;
                          inherit (lib.lists) all;

                          anyPredicate = preds: value: builtins.any (pred: pred value) preds;
                          allPredicates = preds: value: all (pred: pred value) preds;
                        in
                        anyPredicate [
                          isDerivation
                          (allPredicates [
                            lib.isList
                            (all isDerivation)
                          ])
                        ];
                    in
                    pipe dependencies [
                      (lib.collect isDependency)
                      lib.flatten
                      lib.unique
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
                    description = "Emacs package providing the constant for Heitor's Emacs configuration directory";
                  };
                }
              ) { };
            }
          );
      }
    )
  ];
}
