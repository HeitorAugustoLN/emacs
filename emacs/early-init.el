;;; early-init.el --- Early initialization file for Heitor's Emacs configuration -*- lexical-binding: t; -*-

(if (require 'heitor-emacs-directory nil :no-error)
    ;; Using wrapped Nix package: load the generated autoloads
    (require 'heitor-emacs-configuration-autoloads nil :no-error)
  ;; Not using wrapped Nix package: use the new user-lisp directory,
  ;; where autoloads are automatically generated and loaded by Emacs.
  (setopt user-lisp-directory (locate-user-emacs-file "heitor-lisp/")))

(provide 'early-init)

;;; early-init.el ends here