;;; early-init.el --- Early initialization file for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(if (require 'heitor-emacs-directory nil :no-error)
    ;; Using wrapped Nix package: load the generated autoloads
    (require 'heitor-emacs-configuration-autoloads nil :no-error)
  ;; Not using wrapped Nix package: use the new user-lisp directory,
  ;; where autoloads are automatically generated and loaded by Emacs.
  (setopt user-lisp-directory (locate-user-emacs-file "modules/")))

(setopt gnutls-min-prime-bits 3072
        gnutls-verify-error t
        tls-checktrust t)

(setopt custom-file (make-temp-file "emacs-custom-"))

(unless noninteractive
  (when (boundp 'pgtk-wait-for-event-timeout)
    (setopt pgtk-wait-for-event-timeout 0.001))

  (setopt inhibit-startup-screen t
          inhibit-x-resources t)

  ;; Remove "For information about GNU Emacs..." message at startup
  (advice-add 'display-startup-echo-area-message :override #'ignore))

(setopt package-archives
          '(("gnu" . "https://elpa.gnu.org/packages/")
            ("nongnu" . "https://elpa.nongnu.org/nongnu/")
            ("melpa" . "https://melpa.org/packages/")
            ("melpa-stable" . "https://stable.melpa.org/packages/"))
        package-archive-priorities
          '(("gnu" . 4)
            ("nongnu" . 3)
            ("melpa" . 2)
            ("melpa-stable" . 1))
        use-package-enable-imenu-support t)

(provide 'early-init)

;;; early-init.el ends here
