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
        heitor-emacs-nox = wrappedEmacsFor final.emacs-nox;
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
                license = lib.licenses.gpl3Plus;
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
                  aggressive-indent,
                  corfu,
                  ef-themes,
                  fontaine,
                  ghostel,
                  gnome-dark-style,
                  marginalia,
                  modus-alabaster,
                  multiple-cursors,
                  move-text,
                  nix-mode,
                  nix-ts-mode,
                  no-littering,
                  paredit,
                  orderless,
                  vertico,

                  # External dependencies (LSPs, formatters, fonts, treesitter grammars, etc.)
                  adwaita-fonts,
                  iosevka,
                  marksman,
                  magit,
                  nixd,
                  nixfmt,
                  treesit-grammars,
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
                        fonts = [
                          adwaita-fonts
                          iosevka
                        ];

                        emacsPackages = [
                          aggressive-indent
                          corfu
                          ef-themes
                          fontaine
                          ghostel
                          gnome-dark-style
                          magit
                          marginalia
                          modus-alabaster
                          move-text
                          multiple-cursors
                          nix-mode
                          nix-ts-mode
                          no-littering
                          paredit
                          orderless
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
                    description = "HeitorAugustoLN's Emacs configuration";
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
                    description = "HeitorAugustoLN's Emacs configuration directory constant";
                  };
                }
              ) { };

              modus-alabaster = efinal.callPackage (
                {
                  lib,
                  melpaBuild,
                  fetchFromGitHub,
                  modus-themes,
                }:
                melpaBuild {
                  pname = "modus-alabaster";
                  version = "0-unstable-2026-09-27";

                  src = fetchFromGitHub {
                    owner = "dpassen";
                    repo = "modus-alabaster";
                    rev = "29369bf9900f1511be20f3021bde0bbe56dc3b28";
                    hash = "sha256-XOJweRwVn7t4jPMg9GXiZlqGi8e0ccf7sstwZLBHPp0=";
                  };

                  packageRequires = [ modus-themes ];

                  meta = {
                    description = "Alabaster themes implemented on top of Modus themes";
                    homepage = "https://github.com/dpassen/modus-alabaster";
                    license = lib.licenses.gpl3Only;
                    maintainers = [ lib.maintainers.HeitorAugustoLN ];
                  };
                }
              ) { };
            }
          );
      }
    )
  ];
}
