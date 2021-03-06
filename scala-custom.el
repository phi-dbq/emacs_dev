;; additional .el load path
(setq elisp_path "~/CodeBase/emacs_dev")

(defun scala-insert-left-arrow () (interactive) (insert "<-"))
(defun scala-insert-typesafe-arrow () (interactive) (insert "~>"))
;;(add-to-list 'load-path (concat elisp_path "/scala-mode2"))
;;(require 'scala-mode2)
(add-to-list 'load-path (concat elisp_path "/emacs-scala-mode"))
(require 'scala-mode)
(require 'spark-shell-mode)
(require 'sbt-amm-mode)
(add-to-list 'auto-mode-alist '("\\.sclpt\\'" . scala-mode))
(add-to-list 'auto-mode-alist '("\\.scala\\'" . scala-mode))
(defun scala-mode-keybindings ()
  ;;(local-set-key (kbd "C-c C-r") 'scala-eval-region)
  ;;(local-set-key (kbd "C-c C-r") 'sbt-paste-region)
  ;;(local-set-key (kbd "C-c C-p") 'sbt-paste-region)
  ;;(local-set-key (kbd "C-c C-c") 'scala-eval-definition)

  ;; (local-set-key (kbd "C-c C-s C-z") 'run-spark-shell)
  ;; (local-set-key (kbd "C-c C-s C-r") 'spark-shell-eval-region)
  ;; (local-set-key (kbd "C-c C-s C-c") 'spark-shell-eval-definition)

  (local-set-key (kbd "C-c C-m C-z") 'run-amm-shell)
  (local-set-key (kbd "C-c C-m C-r") 'amm-shell-eval-region)
  (local-set-key (kbd "C-c C-p") 'amm-shell-eval-region)
  (local-set-key (kbd "M-_") 'scala-insert-left-arrow)
  (local-set-key (kbd "M-+") 'scala-insert-typesafe-arrow)
  )
(add-hook 'scala-mode-hook 'scala-mode-keybindings)
 
(add-to-list 'load-path (concat elisp_path "/emacs-sbt-mode"))
;; Scal SBT mode custom keys
(use-package sbt-mode
  :commands sbt-start sbt-command  
  :init
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  (setq sbt:program-name "./sbt")
  :bind (("C-c C-b C-c" . sbt-start)
         :map scala-mode-map
         ("C-c C-b C-r" . sbt-send-region)
         ("C-c C-b C-p" . sbt-paste-region))
  :config
  (setq sbt:program-name "./sbt")
  )
