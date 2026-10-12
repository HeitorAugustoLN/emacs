;;; heitor-move-text.el --- Move text configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package move-text
  :ensure t
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

(provide 'heitor-move-text)

;;; heitor-move-text.el ends here
