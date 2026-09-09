;;; heitor-eglot.el --- Eglot configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package eglot
  :hook ((nix-ts-mode . eglot-ensure)
         (markdown-ts-mode . eglot-ensure)))

(provide 'heitor-eglot)

;;; heitor-eglot.el ends here
