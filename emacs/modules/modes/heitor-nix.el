;;; heitor-nix.el --- Nix support for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(require 'heitor-tree-sitter)

(use-package nix-mode
  :ensure t)

(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'"
  :hook (nix-ts-mode . eglot-ensure)
  :init
  (add-to-list
   'treesit-language-source-alist
   '(nix "https://github.com/nix-community/tree-sitter-nix"))
  (heitor-set-treesit-font-lock-level 4 'nix-ts-mode))
(provide 'heitor-nix)

;;; heitor-nix.el ends here
