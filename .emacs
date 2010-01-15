;; emacs startup file
(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;;; Basic stuff

;; Google Style! Yay!
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(require 'ido)
(ido-mode t)

;; Turn off those fucking beeps for good!
(setq ring-bell-function (lambda () ))

(setq inhibit-startup-message t)
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)
(setq-default indent-tabs-mode nil)

(column-number-mode t)
(setq compilation-window-height 11)

(tool-bar-mode -1)
(scroll-bar-mode -1)
;(blink-cursor-mode -1)
(unless window-system (menu-bar-mode -1))

;; When a region is selected, typing anything replaces the region.
(delete-selection-mode t)

;; File type associations
(setq auto-mode-alist
      (append '(("\\.h$" . c++-mode)
                ("\\SConstruct" . python-mode)
                ("\\SConscript" . python-mode))
              auto-mode-alist) )

;; Disable annoying backup files (stupid tildes!)
(setq make-backup-files nil)

;; Default compile command (usually "scons" or "make")
(setq compile-command "scons")

;; Get rid of trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;; Appearance

;; Fonts
(setq default-frame-alist
      '(
        (font . "-apple-courier-medium-r-normal--14-0-72-72-m-0-iso10646-1")
        (width . 95) (height . 46)
        ))


;;; Key Bindings

(global-set-key (kbd "C--") 'recompile)
(global-set-key [F7] 'compile)
(global-set-key [(control z)] 'undo)
(global-set-key [(control x) (control k)] 'kill-region)
(global-set-key [(control m)] 'newline-and-indent)
(global-set-key [(meta g)] 'goto-line)

;; Fancy word deletion
(global-set-key [(control w)] 'kill-syntax-backward)
(global-set-key [(meta d)] 'kill-syntax-forward)

(defun kill-syntax-forward ()
  "Kill characters with syntax at point."
  (interactive)
  (kill-region (point)
               (progn (skip-syntax-forward (string (char-syntax (char-after))))
                      (point) )))

(defun kill-syntax-backward ()
  "Kill characters with syntax at point."
  (interactive)
  (kill-region (point)
               (progn (skip-syntax-backward (string (char-syntax (char-before))))
                      (point) )))

(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
            (line-beginning-position 2)))))

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
            (line-beginning-position 2)))))

;; Smart Tabbing

(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
   the minibuffer. Else, if mark is active, indents region. Else if
   point is at the end of a symbol, expands it. Else indents the
   current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
        (dabbrev-expand nil))
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))
      (if (looking-at "\\_>")
          (dabbrev-expand nil)
        (indent-for-tab-command)))))

(global-set-key [tab] 'smart-tab)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-offsets-alist (quote ((inextern-lang . 0))))
 '(fringe-mode (quote (nil . 0)) nil (fringe)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
