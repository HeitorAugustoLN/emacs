;;; heitor-undo.el --- Undo configuration for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(setopt undo-limit (* 13 160000)
        undo-strong-limit (* 13 240000)
        undo-outer-limit (* 13 24000000))

(provide 'heitor-undo)

;;; heitor-undo.el ends here
