;;; heitor-completion.el --- Heitor's completion configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

(use-package marginalia
  :after vertico
  :config
  (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode))

(provide 'heitor-completion)

;;; heitor-completion.el ends here
