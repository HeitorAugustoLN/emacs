;;; heitor-theme.el --- Heitor's theme configuration -*- lexical-binding: t; -*-

;;; Code:

(defconst heitor-gnome-session-p
  (not (null (member "GNOME"
                     (split-string (or (getenv "XDG_CURRENT_DESKTOP") "")
                                   ":" :omit-empty))))
  "Non-nil when GNOME is among active desktops.")

(use-package modus-alabaster
  :vc (:url "https://github.com/dpassen/modus-alabaster"
            :rev :newest
	          :branch "main")
  :config
  (load-theme 'modus-alabaster-light :no-confirm))

(provide 'heitor-theme)

;;; heitor-theme.el ends here
