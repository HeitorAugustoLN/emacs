;;; heitor-tree-sitter.el --- Tree-sitter configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(defun heitor-set-treesit-font-lock-level (level &optional mode)
  "Set Tree-sitter font-lock LEVEL, optionally for MODE.

If MODE is nil, set LEVEL as the default.  Otherwise, set LEVEL
for MODE, replacing any existing entry while preserving all other
settings.

Keep `treesit-font-lock-level' as an integer when only a default
is set, and use an alist when mode-specific settings are present.

See `treesit-font-lock-level' for details about LEVEL and
mode-specific fontification."
  (let* ((key (or mode t))
         (levels (if (integerp treesit-font-lock-level)
                     (list (cons t treesit-font-lock-level))
                   (copy-tree treesit-font-lock-level)))
         (levels (cons (cons key level)
                       (assq-delete-all key levels))))
    (setopt treesit-font-lock-level (if (and (null mode)
                                             (null (cdr levels)))
                                        level
                                      levels))))

(use-package treesit
  :custom
  (treesit-auto-install-grammar 'always)
  (treesit-enabled-modes t)
  (treesit-font-lock-level 3))

(provide 'heitor-tree-sitter)

;;; heitor-tree-sitter.el ends here
