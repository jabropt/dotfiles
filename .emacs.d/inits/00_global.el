(setq-default tab-width 2
              indent-tabs-mode nil
              truncate-partial-width-windows t
              truncate-lines t)

(setq scroll-step 1
      echo-keystrokes 0.1
      make-backup-files nil
      auto-save-default nil)

(set-face-foreground 'minibuffer-prompt "white")

;; key bindings
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-x C-z z") 'suspend-frame)
(global-set-key (kbd "C-i") 'indent-for-tab-command)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-o") 'other-window)
(global-set-key (kbd "C-z") 'undo)
(define-key input-decode-map (kbd "C-h") (kbd "DEL"))

;; kill and yank
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; minor modes
(line-number-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(global-font-lock-mode 1)

;; packages
(use-package hl-line
  :init (global-hl-line-mode 1)
  :config (setq hl-line-face 'underline))

(use-package linum
  :init (global-linum-mode t)
  :config (setq linum-format "%3d "))

(use-package anzu
  :init (global-anzu-mode +1))

(use-package auto-complete-config
    :init (ac-config-default)
    :config (add-to-list 'ac-modes 'enh-ruby-mode))

(use-package git-gutter
  :init (global-git-gutter-mode 1)
  :bind (("M-p" . git-gutter:previous-hunk)
         ("M-n" . git-gutter:next-hunk)))

(use-package magit
  :init
  (add-hook 'git-commit-mode-hook 'auto-complete-mode)
  (add-hook 'git-commit-mode-hook 'ac-emoji-setup)
  :bind (("C-x g" . magit-status)))

(use-package flycheck
  :init (progn
          (add-hook 'after-init-hook 'global-flycheck-mode))
  :config (progn
            (setq flycheck-display-errors-delay 0.3)
            (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc html-tidy))
            (set-face-foreground 'flycheck-error "red"))
  :bind (("C-c C-l" . flycheck-list-errors)))

(use-package open-junk-file
  :commands open-junk-file
  :config (setq open-junk-file-format "~/junk/%Y%m%d-%H%M%S."))
  :bind (("C-x j" . open-junk-file)))

(use-package recentf
  :init (recentf-mode 1)
  :config (progn
            (setq recentf-max-saved-items 10000)
            (run-with-idle-timer 30 t 'recentf-save-list)))

(use-package saveplace
  :config (setq-default save-place t))

(use-package which-func
  :init (which-function-mode 1))

(use-package yasnippet
  :init (yas-global-mode 1))

(use-package smartparens
  :init
  (progn
    (use-package smartparens-config)
    (use-package smartparens-ruby)
    (use-package smartparens-html)
    (smartparens-global-mode 1)
    (show-smartparens-global-mode 1))
  :config
  (progn
    (setq smartparens-strict-mode t)
    (sp-local-pair 'emacs-lisp-mode "`" nil :when '(sp-in-string-p)))
  :bind
  (("C-M-k" . sp-kill-sexp-with-a-twist-of-lime)
   ("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)
   ("C-M-n" . sp-up-sexp)
   ("C-M-d" . sp-down-sexp)
   ("C-M-u" . sp-backward-up-sexp)
   ("C-M-p" . sp-backward-down-sexp)
   ("C-M-w" . sp-copy-sexp)
   ("M-s" . sp-splice-sexp)
   ("M-r" . sp-splice-sexp-killing-around)
   ("C-)" . sp-forward-slurp-sexp)
   ("C-}" . sp-forward-barf-sexp)
   ("C-(" . sp-backward-slurp-sexp)
   ("C-{" . sp-backward-barf-sexp)
   ("M-S" . sp-split-sexp)
   ("M-J" . sp-join-sexp)
   ("C-M-t" . sp-transpose-sexp)))

(set-fontset-font
 t 'symbol
    (font-spec :family "Apple Color Emoji") nil 'prepend)

(use-package undo-tree
  :init
  (global-undo-tree-mode))
