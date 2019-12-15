;; package -- Summary
;;; Commentary:

;;; Code:
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(make-directory "~/.emacs.d/autosaves/" t)(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t))

(setq
   backup-by-copying t
   backup-directory-alist
    '(("." . "~/.emacs.d/auto-save-list"))
   delete-old-versions t
   kept-new-versions 2000
   kept-old-versions 0
   version-control t)

(require 'backup-each-save)
(add-hook 'after-save-hook 'backup-each-save)

;; https://lists.gnu.org/archive/html/emacs-devel/2017-09/msg00211.html
;; Enriched Text mode has its support for decoding 'x-display' disabled.
;; This feature allows saving 'display' properties as part of text.
;; Emacs 'display' properties support evaluation of arbitrary Lisp forms
;; as part of instantiating the property, so decoding 'x-display' is
;; vulnerable to executing arbitrary malicious Lisp code included in the
;; text (e.g., sent as part of an email message).
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))

(load-theme 'base16-atelier-forest t)

(add-hook 'after-init-hook 'global-company-mode)
(require 'company-terraform)
(company-terraform-init)

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi)
  (eval-after-load 'jedi
    '(progn
       (define-key jedi-mode-map (kbd "C-c ?") nil)
       (define-key jedi-mode-map (kbd "C-c /") nil))))

(add-hook 'python-mode-hook 'my/python-mode-hook)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(add-hook 'go-mode-hook (lambda () (interactive) (setq tab-width 4)))

(add-hook 'python-mode-hook 'jedi:setup)

(column-number-mode t)
(require 'flycheck)

(electric-indent-mode 0)

(global-git-gutter-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-pycheckers-checkers (quote (pylint mypy3 pyflakes bandit)))
 '(flycheck-pycheckers-venv-root "~/.pyenv/versions/")
 '(git-gutter:ask-p nil)
 '(git-gutter:handled-backends (quote (git)))
 '(git-gutter:update-interval 2)
 '(git-gutter:visual-line t)
 '(helm-ff-newfile-prompt-p t)
 '(package-selected-packages
   (quote
    (kubernetes sudo-edit plantuml-mode flycheck-golangci-lint flycheck-gometalinter flymake-go flycheck-pycheckers pyvenv backup-each-save exec-path-from-shell company-jedi use-package helm-projectile pipenv projectile pyenv-mode tide rainbow-mode nvm multiple-cursors markdown-mode less-css-mode helm-ag go-mode git-gutter-fringe dockerfile-mode docker-compose-mode company-terraform base16-theme adaptive-wrap)))
 '(plantuml-jar-path "~/.emacs.d/elpa/plantuml-mode-20190510.657/plantuml.jar")
 '(savehist-mode t))

(require 'git-gutter-fringe)

(set-face-foreground 'git-gutter:modified "#CEB300")
(set-face-background 'git-gutter:modified "#CEB300")
(set-face-foreground 'git-gutter:added    "#0E3389")
(set-face-background 'git-gutter:added    "#0E3389")
(set-face-foreground 'git-gutter:deleted  "#803C3C")
(set-face-background 'git-gutter:deleted  "#803C3C")

(add-hook 'json-mode-hook (lambda () (interactive) (setq tab-width 2)))

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview))

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

(defun pyenv-activate-current-project ()
  "Automatically activates pyenv version if .python-version file exists."
  (interactive)
  (let ((python-version-directory (locate-dominating-file (buffer-file-name) ".python-version")))
    (if python-version-directory
        (let* ((pyenv-version-path (f-expand ".python-version" python-version-directory))
               (pyenv-current-version (s-trim (f-read-text pyenv-version-path 'utf-8))))
          (pyenv-mode-set pyenv-current-version)
          (message (concat "Setting virtualenv to " pyenv-current-version))))))

(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

(use-package pyenv-mode
  :hook (python-mode . pyenv-activate-current-project)
  :init
  (add-to-list 'exec-path "~/.pyenv/shims")
  (setenv "WORKON_HOME" "~/.pyenv/versions/")
  :config
  (pyenv-mode))

(defvar pyenv-current-version nil nil)

(defun pyenv-init()
  "Initialize pyenv's current version to the global one."
  (let ((global-pyenv (replace-regexp-in-string "\n" "" (shell-command-to-string "pyenv global"))))
    (message (concat "Setting pyenv version to " global-pyenv))
    (pyenv-mode-set global-pyenv)
    (setq pyenv-current-version global-pyenv)))

(add-hook 'after-init-hook 'pyenv-init)

(global-flycheck-mode 1)
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))
(defvar flycheck-check-syntax-automatically)
(setq flycheck-check-syntax-automatically '(save))

(let ((govet (flycheck-checker-get 'go-vet 'command)))
  (when (equal (cadr govet) "tool")
    (setf (cdr govet) (cddr govet))))

(require 'rainbow-mode)

(recentf-mode 1)

(require 'sudo-edit)

(helm-mode 1)
(helm-autoresize-mode 1)
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
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))

(winner-mode 1)

;Custom commands
(defun reload-init ()
  "Reload init.el without restarting."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(defun flush-blank-lines ()
  "Remove any blank lines from the entire buffer."
  (interactive)
  (flush-lines "^$"))

(defun unix-newline ()
  "Convert all Windows newlines to Unix styles line endings."
  (set-buffer-file-coding-system 'utf-8))
(add-hook 'before-save-hook 'unix-newline)
(add-hook 'before-save-hook 'whitespace-cleanup)

(defun restart-shell ()
  "Restart (or start a new) shell in current buffer."
  (interactive)
  (shell (current-buffer)))

(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
With argument N, make N copies.
With negative N, comment out original line and use the absolute value.
Taken from https://stackoverflow.com/a/4717026/881224"
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region        ;Get region if active, otherwise line
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
                          (newline))))))
        (dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
          (insert text))))
    (if use-region nil                  ;Only if we're working with a line (not a region)
      (let ((pos (- (point) (line-beginning-position)))) ;Save column
        (if (> 0 n)                             ;Comment out original with negative arg
            (comment-region (line-beginning-position) (line-end-position)))
        (forward-line 1)
        (forward-char pos)))))

;custom keys
;;;;;;;;;;;;
;global
(global-set-key [(control f5)] 'restart-shell)
(global-set-key [(control f9)] 'reload-init)
(global-set-key [(control f11)] 'show-file-name)
(global-set-key [(control f12)] 'describe-key)
(global-set-key [(control tab)] 'company-complete)
(global-set-key (kbd "C-M-s-<up>") 'shrink-window)
(global-set-key (kbd "C-M-s-<down>") 'enlarge-window)
(global-set-key (kbd "C-M-s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-M-s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-c C-_") 'helm-recentf)
(global-set-key (kbd "C-c /") 'comment-region)
(global-set-key (kbd "C-c ?") 'uncomment-region)
(global-set-key (kbd "C-c S") 'sort-lines)
(global-set-key (kbd "C-c R") 'reverse-region)
(global-set-key (kbd "C-c W") 'flush-blank-lines)
(global-set-key (kbd "C-c a g") 'helm-do-ag-project-root)
(global-set-key (kbd "C-c b") 'rename-buffer)
(global-set-key (kbd "C-c d") 'duplicate-line-or-region)
(global-set-key (kbd "C-c w") 'whitespace-cleanup)
(global-set-key (kbd "C-S-t") 'recentf-open-most-recent-file)
(global-set-key (kbd "C-S-z") (lambda () (interactive) (forward-whitespace -1)))
(global-set-key (kbd "C-x c o") 'git-gutter:revert-hunk)
(global-set-key (kbd "C-x C-z") nil) ;; stop annoying suspend frame behavior
(global-set-key (kbd "C-x !") 'winner-undo)
(global-set-key (kbd "C-x @") 'winner-redo)
(global-set-key (kbd "M-{") 'previous-buffer)
(global-set-key (kbd "M-}") 'next-buffer)
(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-<down>") 'forward-paragraph)
(global-set-key (kbd "M-k") 'kill-this-buffer)
(global-set-key (kbd "M-u") 'revert-buffer)
(global-set-key (kbd "M-s-<up>") 'windmove-up)
(global-set-key (kbd "M-s-<right>") 'windmove-right)
(global-set-key (kbd "M-s-<down>") 'windmove-down)
(global-set-key (kbd "M-s-<left>") 'windmove-left)

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
(setq-default truncate-lines 1)
(show-paren-mode 1)

;extra mode configs
(setq-default indent-tabs-mode nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; this gets ag working
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))
(exec-path-from-shell-initialize)

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
