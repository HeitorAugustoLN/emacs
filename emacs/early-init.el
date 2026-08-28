;;; -*- lexical-binding: t; -*-

(unless (require 'heitor-emacs-directory nil t)
  (setopt user-lisp-directory (locate-user-emacs-file "heitor-lisp/")))