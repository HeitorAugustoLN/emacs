;;; early-init.el --- Early initialization file for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Heitor Augusto
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(setopt custom-file (make-temp-file "emacs-custom-")
        load-prefer-newer t)

(if (require 'heitor-emacs-directory nil :no-error)
    ;; Using wrapped Nix package: load the generated autoloads
    (require 'heitor-emacs-configuration-autoloads nil :no-error)
  ;; Not using wrapped Nix package: use the new user-lisp directory,
  ;; where autoloads are automatically generated and loaded by Emacs.
  (setopt user-lisp-directory (locate-user-emacs-file "modules/")))

(setopt ffap-machine-p-known 'reject
        gnutls-min-prime-bits 3072
        gnutls-verify-error t
        tls-checktrust t)

(setopt read-process-output-max (* 1024 1024)
        process-adaptive-read-buffering nil)

(when (memq system-type '(cygwin ms-dos windows-nt))
  (setopt w32-pipe-read-delay 0
          w32-get-true-file-attributes nil
          w32-pipe-buffer-size (* 128 1024)))

(unless noninteractive
  (when (boundp 'pgtk-wait-for-event-timeout)
    (setopt pgtk-wait-for-event-timeout 0.001))

  (setopt frame-resize-pixelwise t
          inhibit-compacting-font-caches t
          inhibit-startup-screen t
          inhibit-x-resources t)

  (unless (memq initial-window-system '(mac ns))
    (add-to-list 'default-frame-alist '(menu-bar-lines . 0))
    (setopt menu-bar-mode nil))

  (add-to-list 'default-frame-alist '(tool-bar-lines . 0))
  (setopt tool-bar-mode nil)

  ;; Remove "For information about GNU Emacs..." message at startup
  (advice-add 'display-startup-echo-area-message :override #'ignore))

(setopt package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                           ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                           ("melpa" . "https://melpa.org/packages/")
                           ("melpa-stable" . "https://stable.melpa.org/packages/"))
        package-archive-priorities '(("gnu" . 4)
                                     ("nongnu" . 3)
                                     ("melpa" . 2)
                                     ("melpa-stable" . 1)))

(setopt use-package-enable-imenu-support t)

(provide 'early-init)

;;; early-init.el ends here
