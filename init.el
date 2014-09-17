;;; package -- Summary

;;; Commentary:

;;; Code:
(make-directory "~/.emacs.d/autosaves/" t)(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t))

(make-directory "~/.emacs.d/autosaves/" t)
(make-directory "~/.emacs.d/backups/" t)

(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20130724.1750/")
(add-to-list 'load-path	"~/.emacs.d/elpa/markdown-mode-20130726.2142/")

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(load-theme 'zenburn t)

(require 'auto-complete)
(global-auto-complete-mode t)
(ac-set-trigger-key "TAB")

(require 'cider)
(add-hook 'clojure-mode-hook 'cider-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(add-hook 'coffee-mode-hook (lambda () (interactive) (setq tab-width 2)))

(require 'column-marker)
(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-2 100)))
(add-hook 'ruby-mode-hook (lambda () (interactive) (column-marker-3 100)))

(column-number-mode t)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(require 'ido)
(ido-mode t)

(add-hook 'json-mode-hook (lambda () (interactive) (setq tab-width 2)))

(autoload 'markdown-mode "markdown-mode"
       "Major mode for editing Markdown files" t)
    (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
    (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
    (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(setq-default truncate-lines 1)
(add-hook 'markdown-mode-hook 'toggle-truncate-lines)
(add-hook 'markdown-mode-hook 'adaptive-wrap-prefix-mode)

(require 'multiple-cursors)

(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'sass-mode-hook 'rainbow-mode)

(require 'rvm)
(rvm-use-default)

(autoload 'sass-mode "sass-mode")
    (add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))
    (add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))

(global-smartscan-mode 1)

(setq tramp-default-method "ssh")
(eval-after-load 'tramp
  '(vagrant-tramp-enable))

(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets/"))
(yas-global-mode t)

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(column-number-mode t)
 '(custom-safe-themes (quote ("f3d2144fed1adb27794a45e61166e98820ab0bbf3cc7ea708e4bf4b57447ee27" "3ad55e40af9a652de541140ff50d043b7a8c8a3e73e2a649eb808ba077e75792" default)))
 '(fci-rule-color "#383838")
 '(safe-local-variable-values (quote ((lexical-binding . t))))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map (quote ((20 . "#BC8383") (40 . "#CC9393") (60 . "#DFAF8F") (80 . "#D0BF8F") (100 . "#E0CF9F") (120 . "#F0DFAF") (140 . "#5F7F5F") (160 . "#7F9F7F") (180 . "#8FB28F") (200 . "#9FC59F") (220 . "#AFD8AF") (240 . "#BFEBBF") (260 . "#93E0E3") (280 . "#6CA0A3") (300 . "#7CB8BB") (320 . "#8CD0D3") (340 . "#94BFF3") (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))

;Custom functions
(defun reload-init ()
  "Reload init.el without restarting."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(defun flush-blank-lines ()
  "Remove any blank lines from the entire buffer."
  (interactive)
  (flush-lines "^$"))

(defun halve-other-window-height ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (enlarge-window (/ (window-height (next-window)) 2)))

(defun halve-this-window-height ()
  "Shrink current window to use half of the other window's lines."
  (interactive)
  (shrink-window (/ (window-height (next-window)) 2)))

(defun unix-newline ()
  "Convert all Windows newlines to Unix styles line endings."
  (set-buffer-file-coding-system 'utf-8))
(add-hook 'before-save-hook 'unix-newline)
(add-hook 'before-save-hook 'whitespace-cleanup)

(defun restart-shell ()
  "Restart (or start a new) shell in current buffer."
  (interactive)
  (shell (current-buffer)))

(defun new-browser-tab ()
  "Open a new browser tab in the default browser."
  (interactive)
  (shell-command "open http://google.com"))

(defun retabify-buffer ()
  "Apply a reindent operation on the entire buffer."
  (interactive)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun retabify-buffer-to (tab-size)
  "Apply a reindent operation on the entire buffer with new TAB-SIZE."
  (interactive "nNew buffer tab size: ")
  (setq tab-width tab-size)
  (setq js-indent-level tab-size)
  (retabify-buffer))

;custom keys
;;;;;;;;;;;;
;global
(global-set-key [(control f5)] 'restart-shell)
(global-set-key [(control f9)] 'reload-init)
(global-set-key [(control f11)] 'show-file-name)
(global-set-key [(control f12)] 'describe-key)
(global-set-key (kbd "s-{") 'previous-buffer)
(global-set-key (kbd "s-}") 'next-buffer)
(global-set-key (kbd "s-t") 'new-browser-tab)
(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-s-<up>") 'windmove-up)
(global-set-key (kbd "M-s-<right>") 'windmove-right)
(global-set-key (kbd "M-<down>") 'forward-paragraph)
(global-set-key (kbd "M-s-<down>") 'windmove-down)
(global-set-key (kbd "M-s-<left>") 'windmove-left)
(global-set-key (kbd "<s-return>") 'newline-and-indent)
(global-set-key (kbd "C-x a") 'erase-buffer)
(global-set-key (kbd "C-x M-s-<down>") 'halve-this-window-height)
(global-set-key (kbd "C-x M-s-<up>") 'halve-other-window-height)
(global-set-key (kbd "C-c b") 'rename-buffer)
(global-set-key (kbd "C-c n") 'flycheck-next-error)
(global-set-key (kbd "C-c p") 'flycheck-previous-error)
(global-set-key (kbd "C-c ~") 'flycheck-buffer)
(global-set-key (kbd "C-c /") 'comment-region)
(global-set-key (kbd "C-c ?") 'uncomment-region)
(global-set-key (kbd "C-c w") 'whitespace-cleanup)
(global-set-key (kbd "C-c <tab>") 'retabify-buffer)
(global-set-key (kbd "C-c <backtab>") 'retabify-buffer-to)
(global-set-key (kbd "C-c S") 'sort-lines)
(global-set-key (kbd "C-c R") 'reverse-region)
(global-set-key (kbd "C-c W") 'flush-blank-lines)
(global-set-key (kbd "C-z") 'forward-whitespace)
(global-set-key (kbd "C-S-z") (lambda () (interactive) (forward-whitespace -1)))
;multiple-cursors
(global-set-key (kbd "C-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-auto-revert-mode t)
(global-linum-mode t)
(setq default-directory "~")
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(show-paren-mode 1)

(add-hook 'after-init-hook #'global-flycheck-mode)
(defvar flycheck-check-syntax-automatically)
(setq flycheck-check-syntax-automatically '(save))
'flycheck '(setq flycheck-checkers (delq 'html-tidy flycheck-checkers))

;extra mode configs
(setq-default indent-tabs-mode nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

(server-start)

(setq confirm-kill-emacs 'y-or-n-p)

(provide 'init)
;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
