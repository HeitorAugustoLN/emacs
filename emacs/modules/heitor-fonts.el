;;; heitor-fonts.el --- Heitor's font configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package fontaine
  :ensure t
  :custom
  (fontaine-latest-state-file (locate-user-emacs-file "fontaine-latest-state.eld"))
  (fontaine-presets
    '((regular)
      (t
        :default-family "Paper Mono"
        :default-height 130
        :variable-pitch-family "Inter")))
  :config
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))
  (fontaine-mode 1))

(provide 'heitor-fonts)

;;; heitor-fonts.el ends here
