;;; heitor-treesitter.el --- Tree-sitter configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package treesit
  :custom
  (treesit-font-lock-level
    '((t . 3)
      (nix-ts-mode . 4))))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-langs '(nix markdown))
  (treesit-auto-install t)
  :config
  (global-treesit-auto-mode 1))

(provide 'heitor-treesitter)

;;; heitor-treesitter.el ends here
