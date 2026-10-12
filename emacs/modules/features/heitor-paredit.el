;;; heitor-paredit.el --- Paredit configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package paredit
  :ensure t
  :commands paredit-mode
  :hook
  (emacs-lisp-mode . paredit-mode))

(provide 'heitor-paredit)

;;; heitor-paredit.el ends here
