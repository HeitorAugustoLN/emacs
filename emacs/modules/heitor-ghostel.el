;;; heitor-ghostel.el --- Heitor's Ghostel configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package ghostel
  :ensure t)

(use-package ghostel-eshell
  :hook (eshell-load . ghostel-eshell-visual-command-mode))

(provide 'heitor-ghostel)

;;; heitor-ghostel.el ends here
