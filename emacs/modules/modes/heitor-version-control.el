;;; heitor-version-control.el --- Version control support for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package magit
  :ensure t)

(use-package majutsu
  :ensure t
  :after magit)

(provide 'heitor-version-control)

;;; heitor-version-control.el ends here