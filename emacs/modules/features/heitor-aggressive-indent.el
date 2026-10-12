;;; heitor-aggressive-indent.el --- Aggressive Indent configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package aggressive-indent
  :ensure t
  :commands aggressive-indent-mode
  :hook
  ((emacs-lisp-mode scheme-mode) . aggressive-indent-mode))

(provide 'heitor-aggressive-indent)

;;; heitor-aggressive-indent.el ends here
