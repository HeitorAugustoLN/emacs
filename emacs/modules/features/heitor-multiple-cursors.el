;;; heitor-multiple-cursors.el --- Multiple cursors configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package multiple-cursors
  :ensure t
  :custom
  (mc/always-run-for-all t)
  :init
  (which-key-add-key-based-replacements
   "C-c m" "multiple cursors"
   "C-c m i" "insert")
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-c C->" . mc/mark-all-like-this-dwim)
         :prefix-map mc-prefix-map
         :prefix "C-c m"
         ("i n" . mc/insert-numbers)
         ("i l" . mc/insert-letters)))

(provide 'heitor-multiple-cursors)

;;; heitor-multiple-cursors.el ends here
