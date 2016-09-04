;;; package -- Summary

;;; Commentary:

;;; Code:
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" ., temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*", temporary-file-directory t)))

(setq explicit-shell-file-name
      "C:/Program Files/Git/bin/bash.exe")
(setq shell-file-name explicit-shell-file-name)
(add-to-list 'exec-path "C:/Program Files (x86)/Git/bin")

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/auto-save-list"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(load-theme 'base16-atelierforest-dark t)

(add-hook 'after-init-hook 'global-company-mode)

(add-hook 'coffee-mode-hook (lambda () (interactive) (setq tab-width 2)))

(column-number-mode t)
(require 'flycheck)

(electric-indent-mode 0)

(global-git-gutter-mode t)
(custom-set-variables
 '(git-gutter:ask-p nil)
 '(git-gutter:handled-backends (quote (git)))
 '(git-gutter:update-interval 2)
 '(git-gutter:visual-line t)
 '(git-gutter:handled-backends '(git)))

(require 'git-gutter-fringe)

(set-face-foreground 'git-gutter:modified "#CEB300")
(set-face-background 'git-gutter:modified "#CEB300")
(set-face-foreground 'git-gutter:added    "#0E3389")
(set-face-background 'git-gutter:added    "#0E3389")
(set-face-foreground 'git-gutter:deleted  "#803C3C")
(set-face-background 'git-gutter:deleted  "#803C3C")

(add-hook 'json-mode-hook (lambda () (interactive) (setq tab-width 2)))

;; magit does not support git hooks, use with care
(setq magit-commit-arguments (quote ("--no-verify")))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)

(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook
          (lambda ()
            (local-unset-key (kbd "M-<up>"))
            (local-unset-key (kbd "M-<down>"))
            (local-unset-key (kbd "M-<left>"))
            (local-unset-key (kbd "M-<right>"))
            (toggle-truncate-lines)
            (adaptive-wrap-prefix-mode)))

(setq-default truncate-lines 1)

(require 'multiple-cursors)

(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'sass-mode-hook 'rainbow-mode)

(autoload 'sass-mode "sass-mode")
    (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))
    (add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))

(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
(setq tramp-default-method "ssh")

(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets/"))
(yas-global-mode t)

(helm-mode 1)
(helm-autoresize-mode 1)
(helm-push-mark-mode 1)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-D") 'helm-buffer-run-kill-buffers)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)
(add-hook 'typescript-mode-hook 'setup-tide-mode)
(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))

;Custom functions
(defun reload-init ()
  "Reload init.el without restarting."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

;custom keys
;;;;;;;;;;;;
;global
(global-set-key [(control f9)] 'reload-init)
(global-set-key (kbd "M-k") 'kill-this-buffer)
(global-set-key (kbd "M-u") 'revert-buffer)
(global-set-key [(backtab)] 'company-complete)
(global-set-key (kbd "M-{") 'previous-buffer)
(global-set-key (kbd "M-}") 'next-buffer)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<down>") 'windmove-down)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "<s-return>") 'newline-and-indent)
(global-set-key (kbd "C-x a") 'git-gutter:stage-hunk)
(global-set-key (kbd "C-x c i") 'magit-commit)
(global-set-key (kbd "C-x c o") 'git-gutter:revert-hunk)
(global-set-key (kbd "C-x d") 'magit-diff-unstaged)
(global-set-key (kbd "C-x D") 'magit-diff-staged)
(global-set-key (kbd "C-x p") 'magit-push-to-remote)
(global-set-key (kbd "C-x <up>") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x <down>") 'git-gutter:next-hunk)

(global-auto-revert-mode t)
(global-linum-mode t)
(setq default-directory "~")
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(show-paren-mode 1)

;extra mode configs
(setq-default indent-tabs-mode nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

(server-start)

(setq confirm-kill-emacs 'y-or-n-p)

(provide 'init)
;;; init.el ends here
