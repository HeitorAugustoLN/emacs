;;; heitor-commands.el --- Commands for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(dolist (command '(downcase-region
                   narrow-to-page
                   narrow-to-region
                   upcase-region))
  (put command 'disabled nil))

(provide 'heitor-commands)

;;; heitor-commands.el ends here
