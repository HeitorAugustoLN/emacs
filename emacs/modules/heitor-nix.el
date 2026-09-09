;;; heitor-nix.el --- Nix support for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package nix-mode
  :ensure t)

(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

(provide 'heitor-nix)

;;; heitor-nix.el ends here
