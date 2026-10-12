;;; heitor-lines.el --- Heitor's line preferences -*- lexical-binding: t; -*-

;;; Code:

(setopt display-line-numbers-type 'relative
        display-line-numbers-widen t
        display-line-numbers-width 3
        next-line-add-newlines nil
        truncate-lines t
        truncate-partial-width-windows nil
        whitespace-line-column nil
        word-wrap t)

(global-display-line-numbers-mode 1)

(provide 'heitor-lines)

;;; heitor-lines.el ends here
