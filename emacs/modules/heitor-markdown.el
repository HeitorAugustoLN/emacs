;;; heitor-markdown.el --- Markdown support for Heitor's Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package markdown-ts-mode
	:mode ("\\.md\\'" "\\.mdx\\'" "\\.markdown\\'"))

(use-package markdown-ts-mode-x
	:after markdown-ts-mode)

(provide 'heitor-markdown)

;;; heitor-markdown.el ends here
