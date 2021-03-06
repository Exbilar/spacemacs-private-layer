;;; packages.el --- Shell Scripts Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq myshellscripts-packages
      '(
        company
        flycheck
        flycheck-bashate
        ggtags
        insert-shebang
        (sh-script :location built-in)
        ))

(defun myshellscripts/post-init-company ()
  (spacemacs|add-company-backends
    :backends (company-capf company-files)
    :modes sh-mode
    )
  )

(defun myshellscripts/post-init-flycheck ()
  (spacemacs/enable-flycheck 'sh-mode))

(defun myshellscripts/init-flycheck-bashate ()
  (use-package flycheck-bashate
    :defer t
    :init (add-hook 'sh-mode-hook 'flycheck-bashate-setup)))

(defun myshellscripts/init-sh-script ()
  (use-package sh-script
    :defer t
    :init
    (progn
      ;; Add meaningful names for prefix categories
      (spacemacs/declare-prefix-for-mode 'sh-mode "mi" "insert")
      (spacemacs/declare-prefix-for-mode 'sh-mode "mg" "goto")

      ;; Add standard key bindings for insert commands
      (spacemacs/set-leader-keys-for-major-mode 'sh-mode
        "\\" 'sh-backslash-region
        "ic" 'sh-case
        "ii" 'sh-if
        "if" 'sh-function
        "io" 'sh-for
        "ie" 'sh-indexed-loop
        "iw" 'sh-while
        "ir" 'sh-repeat
        "is" 'sh-select
        "iu" 'sh-until
        "ig" 'sh-while-getopts)

      ;; Use sh-mode when opening `.zsh' files, and when opening Prezto runcoms.
      (dolist (pattern '("\\.zsh\\'"
                         "zlogin\\'"
                         "zlogout\\'"
                         "zpreztorc\\'"
                         "zprofile\\'"
                         "zshenv\\'"
                         "zshrc\\'"))
        (add-to-list 'auto-mode-alist (cons pattern 'sh-mode)))

      (defun align-all-backslash ()
        (interactive)
        (align-regexp (point-min) (point-max) "\\(\\s-*\\)\\\\$")
        )
      (defun spacemacs//setup-shell ()
        (when (and buffer-file-name
                   (string-match-p "\\.zsh\\'" buffer-file-name))
          (sh-set-shell "zsh")))
      (add-hook 'sh-mode-hook 'spacemacs//setup-shell))))

(defun myshellscripts/post-init-ggtags ()
  (add-hook 'sh-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun myshellscripts/init-insert-shebang ()
  (use-package insert-shebang
    :defer t
    :init
    (progn
      ;; Insert shebang must be available for non shell modes like python or
      ;; groovy but also in the major mode menu with shell specific inserts
      (spacemacs/set-leader-keys-for-major-mode 'sh-mode
        "i!" 'spacemacs/insert-shebang)
      (spacemacs/set-leader-keys "i!" 'spacemacs/insert-shebang)
      ;; we don't want to insert shebang lines automatically
      (remove-hook 'find-file-hook 'insert-shebang))))
