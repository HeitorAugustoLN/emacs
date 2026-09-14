;;; heitor-completion.el --- Heitor's completion configuration -*- lexical-binding: t; -*-

;;; Code:

(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode))

(provide 'heitor-completion)

;;; heitor-completion.el ends here
