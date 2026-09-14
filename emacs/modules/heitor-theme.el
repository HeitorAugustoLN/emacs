;;; heitor-theme.el --- Heitor's theme configuration -*- lexical-binding: t; -*-

;;; Code:

(defconst heitor-gnome-session-p
  (not (null (member "GNOME"
                     (split-string (or (getenv "XDG_CURRENT_DESKTOP") "")
                                   ":" :omit-empty))))
  "Non-nil when GNOME is among active desktops.")

(use-package ef-themes
  :ensure t
  :config
  (unless heitor-gnome-session-p
    (load-theme 'modus-operandi :no-confirm)))

(use-package gnome-dark-style
  :when heitor-gnome-session-p
  :ensure t
  :custom
  (gnome-light-theme 'modus-operandi)
  (gnome-dark-theme 'modus-operandi)
  :config
  (setopt gnome-dark-style-sync t))

(provide 'heitor-theme)

;;; heitor-theme.el ends here
