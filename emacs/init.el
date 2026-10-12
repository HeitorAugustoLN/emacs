;;; init.el --- Initialization file for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

;; Preferences
(require 'heitor-no-littering)
(require 'heitor-commands)
(require 'heitor-cursor)
(require 'heitor-fonts)
(require 'heitor-lines)
(require 'heitor-indentation)
(require 'heitor-scrolling)
(require 'heitor-startup)
(require 'heitor-undo)
(require 'heitor-theme)

;; Features
(require 'heitor-aggressive-indent)
(require 'heitor-completion)
(require 'heitor-emacs-directory)
(require 'heitor-editorconfig)
(require 'heitor-eglot)
(require 'heitor-move-text)
(require 'heitor-multiple-cursors)
(require 'heitor-tree-sitter)
(require 'heitor-dired)
(require 'heitor-ghostel)
(require 'heitor-paredit)
(require 'heitor-which-key)

;; Modes
(require 'heitor-nix)
(require 'heitor-markdown)
(require 'heitor-version-control)
(provide 'init)

;;; init.el ends here
