;;; heitor-dired.el --- Heitor's Dired configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package dired
  :custom
  (dired-create-destination-dirs 'ask)
  (dired-recursive-copies 'always)
  (dired-vc-rename-file t))

(provide 'heitor-dired)

;;; heitor-dired.el ends here
