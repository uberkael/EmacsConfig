;;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless package--initialized (package-initialize))

(setq auto-save-default nil
      create-lockfiles nil
      delete-old-versions -1
      vc-make-backup-filess t)
(setq initial-scratch-message "")
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Sesiones
(setq desktop-path '("~/"))
(setq desktop-load-locked-desktop t)
(desktop-save-mode 1)

;; (defun desktop-save-main ()
  ;; (desktop-save "~/"))
;; (add-hook 'kill-emacs-hook 'desktop-save-main)

;; Ravenpack exports
;; (setenv "RP_REPOS" "~/git")
;; (setenv "PATH" "$PATH:/opt/acl10.1-smp.64")
;; (setenv "ACL_LOCALE" "C.latin1")
;; (setenv "NLS_LANG" "AMERICAN.WE8ISO8859P1")
;; (setenv "ORACLE_HOME" "/opt/oracle/product/11.2.0.3/client_1/lib")
;; (setenv "LD_LIBRARY_PATH" "$ORACLE_HOME:/usr/lib/x86_64-linux-gnu")
;; (setenv "TNS_ADMIN" "$RP_REPOS/configuration")
;; (setenv "IFILE" "$TNS_ADMIN/tnsnames.ora")


;; Default coding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
;; (set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)

;; Remove cl warnings
(setq byte-compile-warnings '(cl-functions))

;; Make case insensitive search
(setq case-fold-search t)

;; Case control
;; (defadvice upcase-word (before upcase-word-advice activate)
;;   (unless (looking-back "\\b")
;;     (backward-word)))

;; (defadvice downcase-word (before downcase-word-advice activate)
;;   (unless (looking-back "\\b")
;;     (backward-word)))

;; (defadvice capitalize-word (before capitalize-word-advice activate)
;;   (unless (looking-back "\\b")
;;     (backward-word)))

;; (defadvice upcase-region (before upcase-region-advice activate)
;;   (unless (looking-back "\\b")
;;     (backward-word)))

(defun xah-toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Always cycle in this order: Init Caps, ALL CAPS, all lower.
URL `http://xahlee.info/emacs/emacs/modernization_upcase-word.html'
Version 2020-06-26"
  (interactive)
  (let (
        (deactivate-mark nil)
        $p1 $p2)
    (if (use-region-p)
        (setq $p1 (region-beginning) $p2 (region-end))
      (save-excursion
        (skip-chars-backward "[:alpha:]")
        (setq $p1 (point))
        (skip-chars-forward "[:alpha:]")
        (setq $p2 (point))))
    (when (not (eq last-command this-command))
      (put this-command 'state 0))
    (cond
     ((equal 0 (get this-command 'state))
      (upcase-initials-region $p1 $p2)
      (put this-command 'state 1))
     ((equal 1 (get this-command 'state))
      (upcase-region $p1 $p2)
      (put this-command 'state 2))
     ((equal 2 (get this-command 'state))
      (downcase-region $p1 $p2)
      (put this-command 'state 0)))))

(global-unset-key (kbd "M-u"))
(global-unset-key (kbd "M-l"))
(put 'downcase-region 'disabled nil)
(put 'capitalize-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;; (global-set-key (kbd "M-u") 'upcase-region)
;; (global-set-key (kbd "M-l") 'downcase-region)
;; (global-set-key (kbd "M-p") 'capitalize-region)
;; (global-set-key (kbd "M-u") (lambda() (interactive)(upcase-word -1)))
;; (global-set-key (kbd "M-l") (lambda() (interactive)(downcase-word -1)))
;; (global-set-key (kbd "M-p") (lambda() (interactive)(capitalize-word -1)))
(global-set-key (kbd "M-u") 'xah-toggle-letter-case)
(global-set-key (kbd "M-l") 'xah-toggle-letter-case)
(global-set-key (kbd "C-l") 'xah-toggle-letter-case)

;; Titulo de da ventana
;; (setq-default frame-title-format '("%f [%m]"))
(setq frame-title-format `(,(user-login-name) "@" ,(system-name) " " global-mode-string " %b" ))

;; Paquetes

;;; Setup use-package
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
;; (eval-when-compile
;;   (require 'use-package))
;; (setq use-package-always-ensure t)

;; (tool-bar-mode -1)

;;(require 'use-package)
(use-package startup
  :defer t
  :config (setq inhibit-startup-screen t))

;; Customizar teclas sin problemas
(use-package bind-key :ensure t)


;; Wakib-keys
;; https://github.com/darkstego/wakib-keys
(use-package wakib-keys :ensure t)
(wakib-keys 1)
(global-set-key (kbd "C-r") 'query-replace)

;; Evil
(use-package evil
  :ensure t
  :config (bind-key [f1] 'evil-mode))

(use-package ediff
  :defer t
  :ensure nil
  :config
  (setq ediff-window-setup-function #'ediff-setup-windows-plain
	ediff-split-window-function #'split-window-horizontally))

;; imenu
(use-package imenu-list :ensure t
  :config (setq imenu-list-auto-resize t))

(use-package which-key
  :ensure t
  :config
  ;; (setq which-key-show-early-on-C-h t)
  ;; (global-set-key (kbd "<C-f1>") #'which-key)
  (which-key-mode))

;; Helm
(use-package helm
  :ensure t
  :config
  (setq helm-candidate-number-limit 100)
  ;; From https://gist.github.com/antifuchs/9238468>f
  (setq helm-idle-delay 0.0
        helm-input-idle-delay 0.01
        helm-yas-display-key-on-candidate t
        helm-display-header-line nil
        helm-mode-line-string ""
        helm-quick-update t
        helm-M-x-requires-pattern nil
        helm-ff-skip-boring-files t
        helm-M-x-fuzzy-match t
        helm-mode-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-move-to-line-cycle-in-source nil)
  (define-key helm-map [escape] 'keyboard-escape-quit)
  (use-package helm-command
    :config
    ;;(global-set-key (kbd "C-SPC") 'helm-M-x))
    (global-set-key (kbd "M-x") 'helm-M-x))
  (use-package helm-find
    :config
    (global-set-key (kbd "M-f") 'helm-find))
  ;; (use-package helm-find-file
  (use-package helm-for-files
    :config
    (global-set-key (kbd "<C-S-o>") 'helm-for-files))
  (use-package helm-buffers
    :config
    (global-set-key (kbd "C-S-SPC") 'helm-buffers-list))
  ;; Repara autocomletado en el menu coma sly
  (use-package helm-mode
    :config
    ;; (setq completing-read-function 'ido-completing-read)
    ;; (setq completing-read-function 'helm--completing-read-default)
    (helm-mode))
  (use-package helm-elisp
    :config
    (global-set-key (kbd "C-h f") 'helm-apropos)
    (global-set-key (kbd "C-h C-l") 'helm-locate-library))
  (use-package helm-info
    :config
    (global-set-key (kbd "C-h r") 'helm-info-emacs))
  (use-package helm-ring
    :config
    (global-set-key (kbd "C-c k") 'helm-show-kill-ring)
    (global-set-key (kbd "C-c m") 'helm-all-mark-rings)))
;; Helm Tab
(define-key helm-map (kbd "<tab>") 'helm-next-line)
(define-key helm-map (kbd "TAB") 'helm-next-line)
(define-key helm-map (kbd "<backtab>") 'helm-previous-line)
;; Go To Anywhere
(bind-key "C-p" 'helm-for-files)
(bind-key "C-o" 'helm-find-files)

;; Busqueda Helm Swoop
(add-to-list 'load-path "~/.emacs.d/elisp/helm-swoop")
(use-package helm-swoop :ensure t
  :config
  ;; (setq helm-swoop-split-with-multiple-windows nil)
  (setq helm-swoop-split-direction 'split-window-horizontally)
  (setq helm-swoop-use-line-number-face t)
  (setq helm-swoop-move-to-line-cycle t)
  ;; Make search insensitive
  (setq helm-case-fold-search t)
  ;; (setq helm-swoop-use-fuzzy-match nil)
  (define-key helm-swoop-map (kbd "<backtab>") 'helm-previous-line)
  (define-key helm-swoop-map (kbd "<tab>") 'helm-next-line)
  ; (define-key helm-swoop-map [escape] 'keyboard-escape-quit)
  (global-set-key (kbd "C-f") 'helm-swoop)
  ;; (bind-key "C-f" 'helm-swoop)
  (global-set-key (kbd "<f3>") 'helm-swoop-back-to-last-point))

;; If a symbol or phrase is selected, use it as the initial query.
(defun my-minibuffer-setup-hook ()
  ;; select input string (if any).
  (setq this-command-keys-shift-translated t)
  (handle-shift-selection)
  (beginning-of-line))
(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)

;; Projectile (Go to anywhere)
;; (use-package projectile :ensure t)
;; (projectile-mode +1)
;; (define-key projectile-mode-map (kbd "C-p") 'projectile-command-map)
;; (global-set-key (kbd "C-p") 'projectile-command-map)

;; Projectile Helm (Go to anywhere)
;; (use-package helm-projectile :ensure t
;; :config
;; (global-set-key (kbd "C-p") 'helm-projectile-find-file))


;; TODO global-set-key dentro de los plugins
(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  (setq dired-sidebar-subtree-line-prefix "·")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))
(bind-key [C-f12] 'dired-sidebar-toggle-sidebar)
(bind-key [S-f12] 'dired-sidebar-toggle-sidebar)
;; TODO No funciona desactivar Mark Set
                                        ;(global-unset-key (kbd "M-s"))
                                        ;(global-set-key (kbd "M-s") 'dired-sidebar-toggle-sidebar)

;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; Vterm
;; (setq async-shell-command-display-buffer nil)
;; (use-package vterm
;;   :ensure t
;;   :bind (:map vterm-mode-map
;; 	      ("C-<SPC>" . nil)
;; 	      ("C-c u" . nil)))

;; (use-package vterm-toggle
;;   :after vterm
;;   :config
;;   (progn
;;     (setq vterm-toggle-fullscreen-p nil)
;;     (setq vterm-toggle-scope 'project)
;;     (add-to-list 'display-buffer-alist
;; 		 '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
;; 		   (display-buffer-reuse-window display-buffer-at-bottom)
;; 		   (direction . bottom)
;; 		   (dedicated . t) ;dedicated is supported in emacs27
;; 		   (reusable-frames . visible)
;; 		   (window-height . 0.3)))))
;; (global-set-key (kbd "C-c u") #'vterm-toggle)
;; (add-hook 'vterm-toggle-show-hook (lambda ()
;; 				    (global-hl-line-mode -1)))
;; (add-hook 'vterm-toggle-hide-hook (lambda ()
;; 				    (global-hl-line-mode)))

;;; Lisp


;;; SLY
(setq sly-init-function 'sly-init-using-slynk-loader)
(add-to-list 'load-path "~/git/sly")
;; (require 'sly-autoloads)
;; (use-package sly
;;   :ensure t
;;   :config (setq inferior-lisp-program "alisp"))
;; (use-package sly-autoloads :after sly)

;; SLY Stepper
;; (add-to-list 'load-path "~/git/sly-stepper")
;; (require 'sly-stepper-autoloads)

;; (with-eval-after-load 'sly
;;   (add-to-list 'sly-lisp-implementations
;;                '(allegro ("alisp")
;;                '(sbcl ("/usr/bin/sbcl")))))

(with-eval-after-load 'sly
  (setq sly-lisp-implementations (cond ((string-equal system-type "gnu/linux")
                                        '((allegro ("alisp")
                                                   :coding-system utf-8-unix)
                                          (sbcl    ("sbcl")
                                                   :coding-system utf-8-unix)
                                          (cmucl   ("cmucl")
                                                   :coding-system utf-8-unix)
                                          (clozure ("ccl")
                                                   :coding-system utf-8-unix)
                                          (clisp   ("clisp")
                                                   :coding-system utf-8-unix)
                                          (ecl     ("ecl")
                                                   :coding-system utf-8-unix)
                                          (abcl    ("abcl")
                                                   :coding-system utf-8-unix)
                                          (clasp   ("/usr/bin/clasp")
                                                   :coding-system utf-8-unix)))
                                       ((string-equal system-type "windows-nt")
                                        '((sbcl ("sbcl"))))
                                       ((string-equal system-type "darwin")
                                        '((sbcl ("sbcl")))))
        sly-auto-select-connection 'always
        sly-command-switch-to-existing-lisp 'always))

(with-eval-after-load 'sly-mrepl
  (define-key sly-mrepl-mode-map (kbd "<up>")'sly-mrepl-previous-input-or-button)
  (define-key sly-mrepl-mode-map (kbd "<down>") 'sly-mrepl-next-input-or-button)
  (define-key sly-mrepl-mode-map (kbd "<C-dead-acute>") 'sly-mrepl-clear-repl)
  (define-key sly-mrepl-mode-map (kbd "M-<up>") 'isearch-backward)
  ;; (define-key sly-mrepl-mode-map (kbd "M-<up>") 'comint-history-isearch-backward-regexp)
  ;; (define-key sly-mrepl-mode-map (kbd "<left>") #'sly-button-backward)
  ;; (define-key sly-mrepl-mode-map (kbd "<right>") #'sly-button-forward)
  (define-key sly-mrepl-mode-map (kbd "M-n") #'sly-mrepl-next-input-or-button))

;; Permite conexion remota con sly en windows
(defvar *use-dedicated-output-stream* nil
  "When T, dedicate a second stream for sending output to Emacs.")

;; Conexiones
(defun sly-local ()
  (interactive)
  (if (sly-connected-p)
      (call-interactively 'sly)
    (sly-connect "localhost" "4006")))

(defun sly-box ()
  (interactive)
  (sly-connect "10.160.9.55" "4006"))

(defun sly-garm ()
  (interactive)
  (sly-connect "garm.local" "4006"))

(defun sly-marbella-worker1 ()
  (interactive)
  (sly-connect "10.160.9.69" "4006"))

(defun sly-marbella-interface ()
  (interactive)
  (sly-connect "192.168.1.31" "4006"))

(defun sly-dev-mc ()
  (interactive)
  (sly-connect "10.160.9.63" "4006"))

(defun sly-edge-stg ()
  (interactive)
  (sly-connect "10.160.9.79" "4006"))

(defun sly-edge-prod ()
  (interactive)
  (sly-connect "10.160.9.77" "4006"))

(defun sly-migthy ()
(interactive)
  (sly-connect "10.200.0.90" "4006"))

;;        (global-set-key (kbd "<S-f2>") (lambda () (interactive)
;;                                         (find-file "/plink:garm.local:~/git/ravenpack/MisLisp/")
;;                                         (message "Opened:  %s" (buffer-name)))))

(defun launch-mc ()
  (interactive)
  (clede-commands-run "Start MC gen5"))

(defun sly-inspecta ()
  (interactive)
  (let ((bar (thing-at-point 'symbol)))
  (sly-inspect bar)))

;; TODO mejor manera
;; (sly-stickers-toggle-break-on-stickers)
;; TODO click con raton en breaks

;; (define-key sly-mrepl-mode-map (kbd "<C-dead-acute>") 'sly-mrepl-clear-repl)
;; (global-set-key (kbd "<C-dead-acute>") 'sly-mrepl-clear-repl)
;; (global-set-key (kbd "<C-dead-acute>") 'sly-qrepl-clear-repl)
(bind-key "<C-dead-acute>" 'sly-mrepl-clear-repl)

;; (cond ((string-equal system-type "gnu/linux")
;;        (global-set-key (kbd "<f2>")     'sly)
;;        (global-set-key (kbd "<S-f2>")   'sly-connect))
;;       ((string-equal system-type "windows-nt")
;;        (global-set-key (kbd "<f2>")     'sly-garm)
;;        (global-set-key (kbd "<S-f2>") (lambda () (interactive)
;;                                         (find-file "/plink:garm.local:~/git/ravenpack/MisLisp/")
;;                                         (message "Opened:  %s" (buffer-name)))))
;;       ((string-equal system-type "darwin")
;;        (global-set-key (kbd "<f2>")     'sly)
;;        (global-set-key (kbd "<S-f2>")   'sly-connect)))
(bind-key "<C-S-f2>" 'sly-disconnect)
;; Interupt
(bind-key "C-S-c" 'sly-interrupt)
;; MREPL
;; Inspect
(bind-key "<f4>"   'sly-inspecta)
(bind-key "<S-f4>" 'sly-inspector-reinspect)
;; Compile
(bind-key "<f5>"   'sly-compile-and-load-file)
(bind-key "<S-f5>" 'sly-compile-defun)
(bind-key "<M-f5>" 'sly-who-references)
(bind-key "<C-f5>" 'sly-who-calls)
;; Trace
;; Stickers
; (global-unset-key (kbd "<f6>"))
(bind-key "<f6>"   'sly-stickers-dwim)
(bind-key "<S-f6>" 'sly-stickers-toggle-break-on-stickers)
(bind-key "<C-f6>" 'sly-stickers-replay)

;; (global-set-key (kbd "<M-f6>")   'sly-pprint-eval-last-expression)
;; Trace
(bind-key "<f7>"   'sly-trace-dialog-toggle-trace)
(bind-key "<S-f7>" 'sly-toggle-trace-fdefinition)
;; (global-set-key (kbd "<f7>")   'sly-toggle-trace-fdefinition)
;; (global-set-key (kbd "<S-f7>") 'sly-toggle-fancy-trace)
(bind-key "<M-f7>" 'sly-list-threads)
(bind-key "<C-f7>" 'sly-trace-dialog)
;; Eval
(bind-key "<f8>"   'sly-eval-defun)
(bind-key "<S-f8>" 'sly-apropos-all)
(bind-key "<C-f8>" 'sly-macroexpand-1)
;; (bind-key "<S-f8>" 'sly-eval-region)
;; (global-set-key (kbd "<M-f8>")   'sly-eval-describe)

;; Describe Symbol
(bind-key "C-." 'sly-describe-symbol)
(bind-key "C-," 'sly-inspect)
;; (global-set-key (kbd "<C-f8>")   'sly-pprint-eval-region)

;; (global-set-key (kbd "M-<up>")    'isearch-backward)
;; (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat)
;; (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance)

;; Buscar siguientes resultados en isearch
(define-key isearch-mode-map (kbd "<up>") 'isearch-repeat-backward)
(define-key isearch-mode-map (kbd "<down>") 'isearch-repeat-forward)
;; (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
;; (define-key isearch-mode-map (kbd "<down>") 'isearch-repeat-forward)
;; (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat)
;; (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance)


;; (bind-key "<f2>"   'sly)
(bind-key "<f2>"   'sly-local)
(bind-key "<S-f2>" (lambda () (interactive)
                     (let ((current-prefix-arg '-))
                       (call-interactively 'sly))))
(bind-key "<C-f2>" 'sly-connect)

;; Make sure that the bash executable can be found
(cond
 ((string-equal system-type "windows-nt")
  (progn
    (setq explicit-shell-file-name "C:/portable/cygwin/bin/zsh.exe  --login")
    (setq shell-file-name explicit-shell-file-name)
    (add-to-list 'exec-path "C:/portable/cygwin/bin"))))

;; Tramp
;; (require 'tramp)
;; (setq tramp-default-method "ssh")
;; (eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
;; (setq remote-file-name-inhibit-cache nil)
;; (setq vc-ignore-dir-regexp
;;       (format "%s\\|%s"
;;                     vc-ignore-dir-regexp
;;                     tramp-file-name-regexp))
;; (setq tramp-verbose 1)
;; (setq tramp-auto-save-directory (expand-file-name
;;                                  "~/.tramp-autosave"))

;; (setq sly-filename-translations
;;       (list
;;        (sly-create-filename-translator :machine-instance "garm.local"
;;                                        :remote-host "garm.local"
;;                                        :username "kael")))

;; (require 'tramp)
;; (setq tramp-default-method "ssh")
;; (when (eq window-system 'w32)
;;   (setq tramp-default-method "plink")
;;   (when (and (not (string-match putty-directory (getenv "PATH")))
;; 	     (file-directory-p putty-directory))
;;     (setenv "PATH" (concat putty-directory ";" (getenv "PATH")))
;;     (add-to-list 'exec-path putty-directory)))

(when (eq window-system 'w32)
  (setq tramp-default-method "plink"))


(when (string-equal system-type "windows-nt")
  (add-to-list 'tramp-methods
               `("sshw"
                 (tramp-login-program        "fakecygpty ssh")
                 ;; ("%h") must be a single element, see `tramp-compute-multi-hops'.
                 (tramp-login-args           (("-l" "%u" "-o \"StrictHostKeyChecking=no\"") ("-P" "%p") ("-t")
                                              ("%h") ("\"")
                                              (,(format
                                                 "env 'TERM=%s' 'PROMPT_COMMAND=' 'PS1=%s'"
                                                 tramp-terminal-type
                                                 "##"))
                                              ("/bin/sh") ("\"")))
                 (tramp-remote-shell         "/bin/sh")
                 (tramp-remote-shell-login   ("-l"))
                 (tramp-remote-shell-args    ("-c"))
                 (tramp-default-port         22)))

  (add-to-list 'tramp-methods
               `("plinkw"
                 (tramp-login-program        "plink")
                 ;; ("%h") must be a single element, see `tramp-compute-multi-hops'.
                 (tramp-login-args           (("-l" "%u") ("-P" "%p") ("-t")
                                              ("%h") ("\"")
                                              (,(format
                                                 "env 'TERM=%s' 'PROMPT_COMMAND=' 'PS1=%s'"
                                                 tramp-terminal-type
                                                 "$"))
                                              ("/bin/sh") ("\"")))
                 (tramp-remote-shell         "/bin/sh")
                 (tramp-remote-shell-login   ("-l"))
                 (tramp-remote-shell-args    ("-c"))
                 (tramp-default-port         22))))

;; /plink:garm.local:/home/kael

;; (setq tramp-verbose 10)

;; /ssh:garm.local:/home/kael

;; Company
;; (use-package company
;;   :ensure t
;;   :config
;;   (global-company-mode)
;;   (company-quickhelp-mode)
;;   (setq company-require-match nil))
;; (global-set-key "\t" 'company-complete-common)

;; (progn
;; (setq
;;  company-idle-delay 0
;;  company-tooltip-limit 24
;;  commentmpany-idle-delay .2
;;  company-echo-delay 0
;;  company-minimum-prefix-length 2
;;  company-require-match nil
;;  company-dabbrev-ignore-case nil
;;  company-tooltip-align-annotations t
;;  company-dabbrev-downcase nil)
;; (add-to-list 'company-backends '(company-capf :with company-dabbrev))

                                        ; Autocomplete
(use-package company
  :ensure t
  :config
  (setf company-idle-delay 0
        company-idle-delay 0
        company-tooltip-limit 24
        company-echo-delay 0)
  (global-set-key (kbd "C-SPC") #'company-indent-or-complete-common)
  (global-company-mode)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map [escape] 'company-abort)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))
                                        ; Usa el tab para completar
(setq tab-always-indent 'complete)
(setq-default c-tab-always-indent 'complete)
(bind-key "<C-tab>" 'tab-to-tab-stop)
;; (bind-key "<C-tab>" 'next-buffer)

                                        ; Man para company
(use-package company-quickhelp :ensure t)
(company-quickhelp-mode)

;; ; Ripgrep.rg
;; (use-package rg
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "C-S-f") 'rg)
;;   (global-unset-key (kbd "M-f"))
;;   (global-set-key (kbd "M-f") 'rg)
;;   :init
;;   ;; (rg-enable-menu))
;;   (rg-enable-default-bindings))
;; ;; (global-set-key (kbd "C-S-f") 'rgrep)

(use-package deadgrep
  :ensure t
  :config
  (global-set-key (kbd "C-S-f") #'deadgrep))

;;; Indentation and trailing whitespace
(setq-default indent-tabs-mode nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)
(setq-default require-final-newline t)
(customize-set-variable 'require-final-newline t)
;; (add-hook 'before-save-hook (lambda () (setq-local require-final-newline t)))
;; (add-hook 'lisp-mode (lambda () (setq-local require-final-newline t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-map (ansi-color-make-color-map) t)
 '(ansi-color-names-vector
   ["#000000" "#8b0000" "#00ff00" "#ffa500" "#7b68ee" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(ansi-term-color-vector
   [unspecified "#2d2a2e" "#ff6188" "#a9dc76" "#ffd866" "#78dce8" "#ab9df2" "#a1efe4" "#fcfcfa"] t)
 '(background-color "#202020")
 '(background-mode dark)
 '(beacon-color "#d33682")
 '(column-number-mode t)
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#7ec98f")
 '(cua-normal-cursor-color "#7c7c7c")
 '(cua-overwrite-cursor-color "#e5c06d")
 '(cua-read-only-cursor-color "#8ac6f2")
 '(cursor-color "#cccccc")
 '(cursor-type 'bar)
 '(custom-enabled-themes '(sweet))
 '(custom-safe-themes
   '("0f2f1feff73a80556c8c228396d76c1a0342eb4eefd00f881b91e26a14c5b62a" "0231f20341414f4091fc8ea36f28fa1447a4bc62923565af83cfb89a6a1e7d4a" "265f68939a70832a73137ef621b14882f83643882b1f0dfa2cd35b91b95afbcc" "0754c176c3f850e1f90e177e283247749a1ac688faebf05b6016343cb3f00064" "845489fb9f7547e6348a80f942402fc7ac7c6854b0accabc49aeddd8cd4a2bd9" "3f3c48d3835286245137ad2fffbe43c634fef7f33500b008ec3cecc3672e7e3b" "79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" "eb122e1df607ee9364c2dfb118ae4715a49f1a9e070b9d2eb033f1cefd50a908" "dc11cee30927281fe3f5c77372119d639e77e86aa794dce2a6ff019afdfbec9e" "2ab0ac5f4167cca36fb593c7ef7c2cab4d5f560b1805f615e242b50762ba41b3" "e69be42341c0f622a5092f20a435e5848883ac600e9a91778e424ded786a2311" "1f35dedbeacbfe9ed72810478836105b5617da67ca27f717a29bbb8087e8a1ba" "3d4df186126c347e002c8366d32016948068d2e9198c496093a96775cc3b3eaa" "efc8341e278323cd87eda7d7a3736c8837b10ebfaa0d2be978820378d3d1b2e2" "97fbd952a3b01fbace2aa49b3b07692cacc3009883c7219b86e41669c2b65683" "16adc50cc7ade8c67d4d1cbad21a4b9f2098420cc41c4986b70362358b8c5b24" "2db65c4ef21dc93dd0d8f27d890637093e977658b7a70d55bedaaa1b7f973d85" "9375315e4786e5cc84b739537102802c18650f3168cf7c29f7fbb00a54f9b8e0" "d3856ef5a26c9f375f4a084af2e89fa215212fe44540deea941d264d00efead4" "45feb1f130c54e0fc116faa71c784562b41009ffc908cf5cef06b6df4bb60a9a" "246cd0eb818bfd347b20fb6365c228fddf24ab7164752afe5e6878cb29b0204e" "0ac7d13bc30eac2f92bbc3008294dafb5ba5167f2bf25c0a013f29f62763b996" "df85955fd38ee2dae7476a5fa93e58e594df96132871c10ecaf4de95bdae932a" "00b463c48742afe509ae7d1dcfce09471f7203e13a118f1256b208017a978b4e" "46b2d7d5ab1ee639f81bde99fcd69eb6b53c09f7e54051a591288650c29135b0" "fe36e4da2ca97d9d706e569024caa996f8368044a8253dc645782e01cd68d884" "7c20c453ad5413b110ccc3bb5df07d69999d741d29b1f894bd691f52b4abdd31" "4eb69f17b4fa0cd74f4ff497bb6075d939e8d8bf4321ce8b81d13974000baac1" "42ec9eaa86da5f052feed0e35b578681015b9e21ab7b5377a5a34ea9a0a9e1b9" "112caea04e9c30b7b3617532977ade626c81f1d01a74e0a7d09503a1106dc104" "7575474658c34b905bcec30a725653b2138c2f2d3deef0587e3abfae08c5b276" "03c32698863b38cb07bf7e6a54b6c1de81f752a6c4eab3642749007d5dcf0aef" "30b14930bec4ada72f48417158155bc38dd35451e0f75b900febd355cda75c3e" "688ae2e91cb9f9f5459e38a6cc10bc8b14087fa36745ef6c85bd7d834459683c" "a6fc75241bcc7ce6f68dcfd0de2d4c4bd804d0f8cd3a9f08c3a07654160e9abe" "abe5ee8858cd1fbe36304a8c3b2315d3e0a4ef7c8588fcc45d1c23eafb725bb6" "d600c677f1777c1e4bfb066529b5b73c0179d0499dd4ffa3f599a0fb0cfbd501" "5111a41453244802afd93eed1a434e612a8afbdf19c52384dffab129258bab6e" "cdd26fa6a8c6706c9009db659d2dffd7f4b0350f9cc94e5df657fa295fffec71" "16ab866312f1bd47d1304b303145f339eac46bbc8d655c9bfa423b957aa23cc9" "e7b7d1e49adc2b0533b4fe57617c358ecbca80f39d05a30b825b998fa86bc372" "25f81851315ee76bd43cb551767861d24d2450d07e8e3ca412d09adbe28f5f98" "cfd51857f5e80eddece7eb5d30b9afce81f442707207e0d636250d03978a66ec" "2d7a7512372bd7774dc5bb3f9d779a6c843d83d3e32c200a3537593ccd720378" "529c211e86eadecb67b6b64ffdf73e71c4337070bd9b3de053f8f7c5da9e07a2" "77df8c957aea72f8d0f9710609163e0c957a477f95219b69a1a2b00b3f7f62ed" "dc8ad8b5833ae06e373cc3d64be28e67e6c3d084ea5f0e9e77225b3badbec661" "ab729ed3a8826bf8927b16be7767aa449598950f45ddce7e4638c0960a96e0f1" "437cd756e079901ccdecd9c397662a3ee4da646417d7469a1c35aa8e246562fe" "b375fc54d0c535bddc2b8012870008055bf29d70eea151869e6ad7aaaadb0d24" "5a04c3d580e08f5fc8b3ead2ed66e2f0e5d93643542eec414f0836b971806ba9" "660376e0336bb04fae2dcf73ab6a1fe946ccea82b25f6800d51977e3a16de1b9" "9549755e996a2398585714b0af745d2be5387ecf7ec299ff355ec6bef495be88" "6ec768e90ce4b95869e859323cb3ee506c544a764e954ac436bd44702bd666c0" "ecc077ef834d36aa9839ec7997aad035f4586df7271dd492ec75a3b71f0559b3" "776c1ab52648f98893a2aa35af2afc43b8c11dd3194a052e0b2502acca02bfce" "a37d20710ab581792b7c9f8a075fcbb775d4ffa6c8bce9137c84951b1b453016" "3a78cae35163bb71df460ebcfdebf811fd7bc74eaa15428c7e0bccfd4f858d30" "08765d801b06462a3ce7e414cdb747436ccaf0c073350be201d8f87bd0481435" "928ed6d4997ec3cdce10b65c59d0f966a61792a69b84c47155cb5578ce2972be" "5ef596398fb0ceee52c269e2f0ab81c74b4322ab4eb2b014f4f4435c75f06534" "b5e75f219d41e6e3516560ac493d808b621a99847d6128ce8e6c74b1495ce875" "43f03c7bf52ec64cdf9f2c5956852be18c69b41c38ab5525d0bedfbd73619b6a" "1cd4df5762b3041a09609b5fb85933bb3ae71f298c37ba9e14804737e867faf3" "4af38f1ae483eb9335402775b02e93a69f31558f73c869af0d2403f1c72d1d33" "b0334e8e314ea69f745eabbb5c1817a173f5e9715493d63b592a8dc9c19a4de6" "4a201d19d8f7864e930fbb67e5c2029b558d26a658be1313b19b8958fe451b55" "7feeed063855b06836e0262f77f5c6d3f415159a98a9676d549bfeb6c49637c4" "77bd459212c0176bdf63c1904c4ba20fce015f730f0343776a1a14432de80990" "143d897548e5a7efb5cf92c35bd39fe7c90cbd28f9236225ad3e80e1b79cef8a" "3a959a1c1765710e5478882053e56650852821e934c3d98f54860dfb91a52626" "db7f422324a763cfdea47abf0f931461d1493f2ecf8b42be87bbbbbabf287bfe" "24cb0b5666e1e17fb6a378c413682f57fe176775eda015eb0a98d65fbb64b127" "e7ba99d0f4c93b9c5ca0a3f795c155fa29361927cadb99cfce301caf96055dfd" "d678ec420b0ede7ace7adb0fa9f448329e132de2f868b20773e282eb29fb1498" "45e76a1b1e3bd74adb03192bf8d6eea2e469a1cf6f60088b99d57f1374d77a04" "0d75aa06198c4245ac2a8877bfc56503d5d8199cc85da2c65a6791b84afb9024" "fa96a61e4eca5f339ad7f1f3442cb5a83696f6a45d9fe2a7bf3b75fc6912bb91" "e01db763cd9daa56f75df8ebd057f84017ae8b5f351ec90c96c928ad50f3eb25" "5b7c31eb904d50c470ce264318f41b3bbc85545e4359e6b7d48ee88a892b1915" "5ed25f51c2ed06fc63ada02d3af8ed860d62707e96efc826f4a88fd511f45a1d" "de1f10725856538a8c373b3a314d41b450b8eba21d653c4a4498d52bb801ecd2" "f6cdb429a64db06d3db965871b45ed1c666fdce2d3e2c4b810868e4cf4244c92" "1f6039038366e50129643d6a0dc67d1c34c70cdbe998e8c30dc4c6889ea7e3db" "63b2616880ed3fc55a75a6c074f20b4623a6df79be4973ec8ed8e0a0a354d570" "2f5bbfe489923faa1fa1d5df7612004e62a3ae291c6211d6190ff006d447a2c0" "1fbd63256477789327fe429bd318fb90a8a42e5f2756dd1a94805fc810ae1b62" "cc8528fcff6ff85ed132ea83e457a58ae0a49168c93bd752a8c446c61fefcdb5" "2681c80b05b9b972e1c5e4d091efb9ba7bb5fa7dad810d9026bc79607a78f1c0" "5d59bd44c5a875566348fa44ee01c98c1d72369dc531c1c5458b0864841f887c" "ca2e59377dc1ecee2a1069ec7126b453fa1198fed946304abb9a5b8c7ad5404d" "0b0d189e2393d17e30d5101ba53f6798712a415b26de4f164b3fc878f54a5521" "cd8c426a8bd6532ab35d1f846f27feda0688b3ab88e96b8a8dc170835c099309" "b73a23e836b3122637563ad37ae8c7533121c2ac2c8f7c87b381dd7322714cd0" "f99318b4b4d8267a3ee447539ba18380ad788c22d0173fc0986a9b71fd866100" "3325e2c49c8cc81a8cc94b0d57f1975e6562858db5de840b03338529c64f58d1" "2c613514f52fb56d34d00cc074fe6b5f4769b4b7f0cc12d22787808addcef12c" "21055a064d6d673f666baaed35a69519841134829982cbbb76960575f43424db" "0cd00c17f9c1f408343ac77237efca1e4e335b84406e05221126a6ee7da28971" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "0da29071bc0301d3107338a2053267af9050d674f3c5b3dcdc2bb65ac8ab15a5" "f0c94bf6a29c232300e46af50f46ce337e721eacca6d618e8654a263db5ecdbe" "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" "e0628ee6c594bc7a29bedc5c57f0f56f28c5b5deaa1bc60fc8bd4bb4106ebfda" "f4158db802ae689ed0e156cd02c8a3c0e22c5e778578e8eea6d4afc3a9d0e629" "bd82c92996136fdacbb4ae672785506b8d1d1d511df90a502674a51808ecc89f" "cd8d4376a1b94f7063b124adbeb50477fed3feb9bc37be01c66c6005589ad175" "6ca5f925de5c119694dbe47e2bc95f8bad16b46d154b3e2e0ae246fec4100ec5" "bfac9f5b962572739db905a07a2d8d32b25258cd67826727d354013b63d8529e" "a44bca3ed952cb0fd2d73ff3684bda48304565d3eb9e8b789c6cca5c1d9254d1" "aba75724c5d4d0ec0de949694bce5ce6416c132bb031d4e7ac1c4f2dbdd3d580" "ac6e2b8f5c58c4710f59b7d2652bab7b715476696b05f5395f6b5cdd64e41160" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "7b1ea77093c438aa5887b2649ca079c896cc8780afef946d3b6c53931081a726" "409e4d689f1e29e5a18f536507e6dc760ee9da76dc56481aaa0696705e6be968" "cc726c58acb72b579d2d298b9eea99f6ca5fa4e9c90d9414f27530578f1356db" "9eecd688ffd00df3a218a323ceedf3f0f2950dd2347c9b708929a347bf46d2d4" "c0f4b66aa26aa3fded1cbefe50184a08f5132756523b640f68f3e54fd5f584bd" "04e240f3ff3db9616c2535c2895cc3e5f88b92baa62c0239e1c2c9c2d84b9b2d" "a2fddf71e4e7c82ab17737ed44e5601b5dbd2cf9fee295413dcd887b7dab1e93" "5e2cdea6453f8963037723ab91c779b203fb201bf5c377094440f0c465d688ec" "b494aae329f000b68aa16737ca1de482e239d44da9486e8d45800fd6fd636780" "3d2e532b010eeb2f5e09c79f0b3a277bfc268ca91a59cdda7ffd056b868a03bc" "3a2e0c5597f6d74d99daa2b5bbbc2a653d02d6b88fcd73d3c84ebf25cde37b3f" "5a00018936fa1df1cd9d54bee02c8a64eafac941453ab48394e2ec2c498b834a" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "3c7a784b90f7abebb213869a21e84da462c26a1fda7e5bd0ffebf6ba12dbd041" "249e100de137f516d56bcf2e98c1e3f9e1e8a6dce50726c974fa6838fbfcec6b" "06ed754b259cb54c30c658502f843937ff19f8b53597ac28577ec33bb084fa52" "e8567ee21a39c68dbf20e40d29a0f6c1c05681935a41e206f142ab83126153ca" "f00a605fb19cb258ad7e0d99c007f226f24d767d01bf31f3828ce6688cbdeb22" "d9a28a009cda74d1d53b1fbd050f31af7a1a105aa2d53738e9aa2515908cac4c" "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" "3a9f65e0004068ecf4cf31f4e68ba49af56993c20258f3a49e06638c825fbfb6" "d2e0c53dbc47b35815315fae5f352afd2c56fa8e69752090990563200daae434" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "d9646b131c4aa37f01f909fbdd5a9099389518eb68f25277ed19ba99adeb7279" "27a1dd6378f3782a593cc83e108a35c2b93e5ecc3bd9057313e1d88462701fcd" "f703efe04a108fcd4ad104e045b391c706035bce0314a30d72fbf0840b355c2c" "716f0a8a9370912d9e6659948c2cb139c164b57ef5fda0f337f0f77d47fe9073" "7922b14d8971cce37ddb5e487dbc18da5444c47f766178e5a4e72f90437c0711" "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298" "24168c7e083ca0bbc87c68d3139ef39f072488703dcdd82343b8cab71c0f62a7" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "94a94c957cf4a3f8db5f12a7b7e8f3e68f686d76ae8ed6b82bd09f6e6430a32c" "b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97" "549ccbd11c125a4e671a1e8d3609063a91228e918ffb269e57bd2cd2c0a6f1c6" "d2f5f035c857ef7aa496a99d0e1ce28ceaa810fd968086935d475da43a14aa1f" "b7133876a11eb2ded01b4b144b45d9e7457f80dd5900c332241881ab261c50f4" "37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" default))
 '(ensime-sem-high-faces
   '((var :foreground "#9876aa" :underline
          (:style wave :color "yellow"))
     (val :foreground "#9876aa")
     (varField :slant italic)
     (valField :foreground "#9876aa" :slant italic)
     (functionCall :foreground "#a9b7c6")
     (implicitConversion :underline
                         (:color "#808080"))
     (implicitParams :underline
                     (:color "#808080"))
     (operator :foreground "#cc7832")
     (param :foreground "#a9b7c6")
     (class :foreground "#4e807d")
     (trait :foreground "#4e807d" :slant italic)
     (object :foreground "#6897bb" :slant italic)
     (package :foreground "#cc7832")
     (deprecated :strike-through "#a9b7c6")))
 '(ergoemacs-status-mode t)
 '(fci-rule-character-color "#452E2E")
 '(fci-rule-color "#383838")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(font-use-system-font nil)
 '(foreground-color "#cccccc")
 '(frame-background-mode 'dark)
 '(frame-brackground-mode 'dark)
 '(fringe-mode 4 nil (fringe))
 '(global-display-line-numbers-mode t)
 '(helm-completion-style 'helm)
 '(highlight-changes-colors '("#FD5FF0" "#AE81FF"))
 '(highlight-symbol-colors
   '("#37422f301f2f" "#22ea312d259d" "#3c102d062b4c" "#23a7185f2777" "#25be3069390f" "#35b22ae41f58" "#2a192d0c36bb"))
 '(highlight-symbol-foreground-color "#8b8b8b")
 '(highlight-tail-colors
   '(("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100)))
 '(hl-bg-colors
   '("#323013" "#323013" "#323013" "#341307" "#321531" "#183130" "#183130" "#183130"))
 '(hl-fg-colors
   '("#000000" "#000000" "#000000" "#000000" "#000000" "#000000" "#000000" "#000000"))
 '(hl-paren-colors '("#B9F" "#B8D" "#B7B" "#B69" "#B57" "#B45" "#B33" "#B11"))
 '(hl-sexp-background-color "#1c1f26")
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(ibuffer-deletion-face 'diredp-deletion-file-name)
 '(ibuffer-marked-face 'diredp-flag-mark)
 '(imenu-list-minor-mode nil)
 '(inhibit-startup-screen t)
 '(linum-format " %5i ")
 '(lsp-ui-doc-border "#024858")
 '(lsp-ui-imenu-colors '("#7FC1CA" "#A8CE93"))
 '(magit-diff-use-overlays nil)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style 'chamfer)
 '(notmuch-search-line-faces
   '(("unread" :foreground "#aeee00")
     ("flagged" :foreground "#0a9dff")
     ("deleted" :foreground "#ff2c4b" :bold t)))
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-fontify-done-headline nil)
 '(org-fontify-todo-headline nil)
 '(package-selected-packages
   '(doom-themes visual-regexp-steroids acme-search evil which-key helm-sly lush-theme rimero-theme rebecca-theme northcode-theme seoul256-theme paganini-theme ujelly-theme darcula-theme flatland-theme nyx-theme mustard-theme flatland-black-theme abyss-theme snazzy-theme mbo70s-theme mellow-theme colonoscopy-theme firecode-theme mustang-theme busybee-theme dakrone-theme dark-krystal-theme bliss-theme boron-theme monokai-alt-theme sublime-themes arjen-grey-theme flatui-dark-theme blackboard-theme zweilight-theme kosmos-theme darkburn-theme creamsody-theme clues-theme madhat2r-theme noctilux-theme omtose-phellack-theme warm-night-theme farmhouse-theme badwolf-theme forest-blue-theme metalheart-theme oceanic-theme kooten-theme sourcerer-theme liso-theme twilight-anti-bright-theme darkmine-theme caroline-theme toxi-theme idea-darkula-theme dark-mint-theme distinguished-theme hamburg-theme borland-blue-theme ubuntu-theme hc-zenburn-theme cherry-blossom-theme green-phosphor-theme heroku-theme reverse-theme waher-theme badger-theme purple-haze-theme bubbleberry-theme soothe-theme hemisu-theme calmer-forest-theme django-theme underwater-theme soft-charcoal-theme twilight-theme birds-of-paradise-plus-theme ir-black-theme zen-and-art-theme tango-2-theme green-screen-theme atom-dark-theme brutalist-theme foggy-night-theme seti-theme panda-theme mandm-theme arc-dark-theme naquadah-theme color-theme suscolors-theme naysayer-theme minsk-theme sweet-theme undersea-theme one-themes night-owl-theme ayu-theme darkokai-theme iceberg-theme color-theme-sanityinc-solarized lavenderless-theme reykjavik-theme atom-one-dark-theme chocolate-theme enlightened-theme mlso-theme avk-emacs-themes nova-theme ## shades-of-purple-theme leuven-theme purp-theme spacemacs-theme zeno-theme immaterial-theme ancient-one-dark-theme zerodark-theme inkpot-theme timu-spacegrey-theme tangotango-theme molokai-theme gotham-theme remember-last-theme darker-themekaolin-theme nimbus-theme gruber-darker-theme deadgrep visual-regexp symon doom-modeline spaceline spaceline-config ergoemacs-status smart-mode-line diminish all-the-icons helm-projectile helm-swoop good-scroll highlight-symbol rainbow-identifiers rainbow-mode rainbow-blocks hl-block-mode hl-block smartparens-config smartparens hl-todo undo-fu multiple-cursors move-text duplicate-thing kaolin-themes afternoon-theme darktooth-theme ample-theme moe-theme rainbow-delimiters material-theme gruvbox-theme monokai-pro-theme zenburn-theme cyberpunk-theme cyberpunk-2019-theme vscode-icon theme-looper dracula-theme peacock-theme subatomic256-theme subatomic-theme nord-theme monokai-theme centaur-tabs company-quickhelp helm-ring helm-info helm-elisp helm-buffers helm-for-files helm-find helm-command startup rg company wakib-keys vterm-toggle use-package sly-asdf magit helm))
 '(pdf-view-midnight-colors '("#fdf4c1" . "#1d2021"))
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(red "#ffffff")
 '(safe-local-variable-values
   '((Package . POSTMODERN)
     (Base . 10)
     (Syntax . Ansi-Common-Lisp)))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#8ac6f2" "#0b0b0b" 0.2))
 '(term-default-bg-color "#000000")
 '(term-default-fg-color "#7c7c7c")
 '(tetris-x-colors
   [[229 192 123]
    [97 175 239]
    [209 154 102]
    [224 108 117]
    [152 195 121]
    [198 120 221]
    [86 182 194]])
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
 '(when
      (or
       (not
        (boundp 'ansi-term-color-vector))
       (not
        (facep
         (aref ansi-term-color-vector 0)))))
 '(which-key-mode t)
 '(xterm-color-names
   ["#414E63" "#CC71D1" "#88D6CB" "#C79474" "#76A2D1" "#4A4B6B" "#96A9D6" "#8E95A3"])
 '(xterm-color-names-bright
   ["#555B77" "#E074DB" "#8BE8D8" "#B2DEC1" "#75B5EB" "#9198EB" "#C3C3E8" "#838791"])
 '(xterm-mouse-mode t))

;; Clipboard comun
(setq x-select-enable-clipboard t)
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value) ;; name changed problem
(setq interprogram-paste-function 'x-selection-value)

;; Cua Lite
;; (use-package cua-lite :ensure t)
;; :(cua-lite 1)

;; MaGit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))
;; (setq magit-git-executable "git"))
(bind-key "<f9>" 'magit)

;; Evita problemas en git con links symbolic
(setq vc-follow-symlinks t)

;; Auto revert archivo cambiado en disco
(global-auto-revert-mode 1)

;; Delimiter matching
;; (electric-pair-mode 1)
;; Find file in git project
;; (global-set-key (kbd "M-p") 'project-find-file)
;;(ido-mode 1)

;; Show Parents TODO Feo
;; (setq show-paren-delay 0)
;; (show-paren-mode 1)
;; (setq show-paren-style 'parenthesis)
;; (setq show-paren-style 'expression)


(defun lispy-parens ()
  "Setup parens display for lisp modes"
  (setq show-paren-delay 0)
  (setq show-paren-style 'parenthesis)
  (make-variable-buffer-local 'show-paren-mode)
  (show-paren-mode 1)
  ;; (set-face-background 'show-paren-match (face-background 'default))
  (set-face-background 'show-paren-match "#5218fa")
  (if (boundp 'font-lock-comment-face)
      (set-face-foreground 'show-paren-match
     			   (face-foreground 'font-lock-comment-face))
    (set-face-foreground 'show-paren-match
                         (face-foreground 'default)))
  (set-face-attribute 'show-paren-match nil :weight 'extra-bold))
(lispy-parens)

;; Smartparent
(use-package smartparens :ensure t)
(require 'smartparens-config)
(add-hook 'lisp-mode-hook #'smartparens-mode)
(add-hook 'emacs-lisp-mode-hook #'smartparens-mode)
(global-set-key (kbd "C-(")           'sp-backward-sexp)
(global-set-key (kbd "C-)")           'sp-forward-sexp)
;; TODO seleccion continua
(global-set-key (kbd "C-=")           'sp-splice-sexp)
(global-set-key (kbd "C-?")           'sp-select-previous-thing-exchange)
(global-set-key (kbd "M-?")           'sp-select-previous-thing-exchange)
(global-set-key (kbd "C-¿")           'sp-select-next-thing-exchange)
(global-set-key (kbd "M-¿")           'sp-select-next-thing-exchange)
(global-set-key (kbd "M-<delete>")    'sp-kill-sexp)
(global-set-key (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)
(global-set-key (kbd "M-(")           'sp-backward-slurp-sexp)
(global-set-key (kbd "M-)")           'sp-forward-slurp-sexp)
(global-set-key (kbd "M-{")           'sp-backward-barf-sexp)
(global-set-key (kbd "M-}")           'sp-forward-barf-sexp)
;; (global-set-key (kbd "C-?") 'sp-backward-sexp)
;; (global-set-key (kbd "C-¿") 'sp-forward-sexp)
;; (global-set-key (kbd "C-{") 'sp-forward-barf-sexp)
;; (global-set-key (kbd "C-}") 'sp-forward-slurp-sexp)

;; Undo-fu Redo
(use-package undo-fu :ensure t)
(global-set-key (kbd "C-z")      'undo-fu-only-undo)
(global-set-key (kbd "C-S-z")    'undo-fu-only-redo)
(global-set-key (kbd "C-y")      'undo-fu-only-redo)

;; Move text
(use-package move-text :ensure t)
(global-set-key (kbd "<C-up>")   'move-text-up)
(global-set-key (kbd "<C-down>") 'move-text-down)

;; Multiple Cursors TODO
;; (use-package 'multiple-cursors :ensure t)
;; (global-unset-key (kbd "C-<down-mouse-1>"))
;; (global-set-key (kbd "C-<mouse-1>") 'mc/add-cursor-on-click)
(use-package multiple-cursors
  :ensure t
  :bind (("<C-S-up>" . mc/mark-previous-like-this)
         ("<C-S-down>" . mc/mark-next-like-this))
  :config (setq mc/always-run-for-all t))
(with-eval-after-load 'multiple-cursors-core
  (define-key mc/keymap (kbd "<ESC>") 'mc/keyboard-quit))
(local-unset-key (kbd "M-d"))
(bind-key "C-S-d" 'mc/mark-all-like-this)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;; Ace-mc
(use-package ace-mc :ensure t)
(bind-key "M-d" 'ace-mc-add-multiple-cursors)

;; Duplicate
(use-package duplicate-thing :ensure t)
(bind-key "C-S-d" 'duplicate-thing)
(global-set-key (kbd"C-S-d") 'duplicate-thing)

;; Visual Regexp
(use-package visual-regexp :ensure t)

;; Delete al copiar
(delete-selection-mode)

;; All the icons
(use-package all-the-icons :ensure t)

;; Centaur Tabs
(use-package centaur-tabs
  :demand
  :ensure t
  :config
  ;; (dolist (centaur-face '(centaur-tabs-selected
  ;;                           centaur-tabs-selected-modified
  ;;                           centaur-tabs-unselected
  ;;                           centaur-tabs-unselected-modified))
  ;;   (set-face-attribute centaur-face nil :family "Consolas Ligaturized" :height 120))
  ;; (centaur-tabs-change-fonts "Consolas Ligaturized" 80)
  (setq centaur-tabs-style "bar"
	centaur-tabs-set-bar 'over
	centaur-tabs-height 32
	centaur-tabs-set-icons t
	centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "*"
	centaur-tabs-show-navigation-buttons t
	x-underline-at-descent-line t
        ;; centaur-tabs-label-fixed-length 10
        ;; centaur-tabs--buffer-show-groups nil
        )
  (setq uniquify-separator "/")
  (setq uniquify-buffer-name-style 'forward)
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t)
  (defun centaur-tabs-buffer-groups ()
    (list
     (cond
      ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
      ;; "Remote")
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode)))
       "Emacs")
      ((or (derived-mode-p 'prog-mode) (derived-mode-p 'fundamental-mode))
       "Editing")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-mode
                          org-agenda-clockreport-mode
                          org-src-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t
       (centaur-tabs-get-group-name (current-buffer))))))
  ;;:hook
  ;; (dashboard-mode . centaur-tabs-local-mode)
  ;; (term-mode . centaur-tabs-local-mode)
  ;; (calendar-mode . centaur-tabs-local-mode)
  ;; (org-agenda-mode . centaur-tabs-local-mode)
  ;; (helpful-mode . centaur-tabs-local-mode)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

;; Simbolos lambda
;; (global-prettify-symbols-mode 1)
;; (global-prettify-symbols-mode 0)
;; (setq prettify-symbols-alist
;;       '(
;;                                         ;("lambda" . 955) ; λ
;;         ("->" . 8594)    ; →
;;         ("=>" . 8658)    ; ⇒
;;         ("map" . 8614)    ; ↦
;;         ))

;; Themes
(use-package kaolin-themes
  :ensure t
  :config
  (kaolin-treemacs-theme))
(use-package abyss-theme :ensure t) ;;
(use-package afternoon-theme :ensure t)
(use-package ample-theme :ensure t)
(use-package ancient-one-dark-theme :ensure t)
(use-package arc-dark-theme :ensure t)
(use-package arjen-grey-theme :ensure t)
(use-package atom-dark-theme :ensure t)
(use-package atom-one-dark-theme :ensure t)
(use-package avk-emacs-themes :ensure t)
(use-package ayu-theme :ensure t)
(use-package badger-theme :ensure t)
(use-package badwolf-theme :ensure t)
(use-package birds-of-paradise-plus-theme :ensure t)
(use-package blackboard-theme :ensure t)
(use-package bliss-theme :ensure t) ;;
(use-package borland-blue-theme :ensure t)
(use-package boron-theme :ensure t)
(use-package brutalist-theme :ensure t)
(use-package bubbleberry-theme :ensure t)
(use-package busybee-theme :ensure t) ;;
(use-package calmer-forest-theme :ensure t)
(use-package caroline-theme :ensure t)
(use-package cherry-blossom-theme :ensure t)
(use-package chocolate-theme :ensure t)
(use-package clues-theme :ensure t)
(use-package colonoscopy-theme :ensure t)
(use-package color-theme-sanityinc-solarized :ensure t)
(use-package creamsody-theme :ensure t)
(use-package cyberpunk-2019-theme :ensure t)
(use-package cyberpunk-theme :ensure t)
(use-package dakrone-theme :ensure t)
(use-package darcula-theme :ensure t) ;;
(use-package dark-krystal-theme :ensure t)
(use-package dark-mint-theme :ensure t)
(use-package darkburn-theme :ensure t)
(use-package darkmine-theme :ensure t)
(use-package darkokai-theme :ensure t)
(use-package darktooth-theme :ensure t)
(use-package distinguished-theme :ensure t)
(use-package django-theme :ensure t)
(use-package dracula-theme :ensure t)
(use-package enlightened-theme :ensure t)
(use-package firecode-theme :ensure t)
(use-package flatland-black-theme :ensure t) ;;
(use-package flatland-theme :ensure t) ;;
(use-package flatui-dark-theme :ensure t) ;;
(use-package foggy-night-theme :ensure t)
(use-package forest-blue-theme :ensure t)
(use-package gotham-theme :ensure t)
(use-package green-phosphor-theme :ensure t)
(use-package green-screen-theme :ensure t)
(use-package gruber-darker-theme :ensure t)
(use-package gruvbox-theme :ensure t)
(use-package hamburg-theme :ensure t)
(use-package hc-zenburn-theme :ensure t)
(use-package hemisu-theme :ensure t)
(use-package heroku-theme :ensure t)
(use-package iceberg-theme :ensure t)
(use-package idea-darkula-theme :ensure t)
(use-package immaterial-theme :ensure t)
(use-package inkpot-theme :ensure t)
(use-package ir-black-theme :ensure t)
(use-package kooten-theme :ensure t)
(use-package kosmos-theme :ensure t)
(use-package lavenderless-theme :ensure t)
(use-package leuven-theme :ensure t)
(use-package liso-theme :ensure t)
(use-package lush-theme :ensure t) ;;
(use-package madhat2r-theme :ensure t) ;;
(use-package mandm-theme :ensure t)
(use-package material-theme :ensure t)
(use-package mbo70s-theme :ensure t) ;;
(use-package mellow-theme :ensure t) ;;
(use-package metalheart-theme :ensure t)
(use-package minsk-theme :ensure t)
(use-package moe-theme :ensure t)
(use-package molokai-theme :ensure t)
(use-package monokai-alt-theme :ensure t) ;;
(use-package monokai-pro-theme :ensure t)
(use-package monokai-theme :ensure t)
(use-package mustang-theme :ensure t) ;;
(use-package mustard-theme :ensure t) ;;
(use-package naquadah-theme :ensure t)
(use-package naysayer-theme :ensure t)
(use-package night-owl-theme :ensure t)
(use-package nimbus-theme :ensure t)
(use-package noctilux-theme :ensure t)
(use-package nord-theme :ensure t)
(use-package northcode-theme :ensure t)
(use-package nova-theme :ensure t)
(use-package nyx-theme :ensure t)
(use-package oceanic-theme :ensure t)
(use-package one-themes :ensure t)
(use-package paganini-theme :ensure t) ;;
(use-package panda-theme :ensure t)
(use-package peacock-theme :ensure t)
(use-package peacock-theme :ensure t) ;;
(use-package purp-theme :ensure t)
(use-package purple-haze-theme :ensure t)
(use-package rebecca-theme :ensure t) ;;
(use-package reverse-theme :ensure t)
(use-package reykjavik-theme :ensure t)
(use-package rimero-theme :ensure t)
(use-package seoul256-theme :ensure t) ;;
(use-package seti-theme :ensure t)
(use-package shades-of-purple-theme :ensure t)
(use-package snazzy-theme :ensure t) ;;
(use-package soft-charcoal-theme :ensure t)
(use-package soothe-theme :ensure t)
(use-package sourcerer-theme :ensure t)
(use-package subatomic-theme :ensure t)
(use-package subatomic256-theme :ensure t)
(use-package suscolors-theme :ensure t)
(use-package sweet-theme :ensure t)
(use-package tango-2-theme :ensure t)
(use-package tangotango-theme :ensure t)
(use-package timu-spacegrey-theme :ensure t)
(use-package toxi-theme :ensure t)
(use-package twilight-anti-bright-theme :ensure t)
(use-package twilight-theme :ensure t)
(use-package ubuntu-theme :ensure t)
(use-package ujelly-theme :ensure t)
(use-package undersea-theme :ensure t)
(use-package underwater-theme :ensure t)
(use-package waher-theme :ensure t)
(use-package warm-night-theme :ensure t)
(use-package zen-and-art-theme :ensure t)
(use-package zenburn-theme :ensure t)
(use-package zeno-theme :ensure t)
(use-package zerodark-theme :ensure t)
(use-package zweilight-theme :ensure t)
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;; Remember theme
;; (use-package remember-last-theme
  ;; :ensure t
  ;; :config (remember-last-theme-enable))
;; (load custom-file) if you are not doing it already)

;; (load-theme 'monokai t)
;; (load-theme 'monokai-pro t)
;; (load-theme 'nord t)
;; (load-theme 'subatomic t)
;; (load-theme 'subatomic256 t)
;; (load-theme 'peacock t)
;; (load-theme 'dracula t)
;; (load-theme 'cyberpunk t)
;; (load-theme 'cyberpunk-2019 t)
;; (load-theme 'zenburn t)
;; (load-theme 'material t)
;; (load-theme 'melancholy t)
;; (load-theme 'moe-dark t)
;; (load-theme 'ample t)
;; (load-theme 'darktooth t)
;; (load-theme 'afternoon t)
;; (load-theme 'kaolin-aurora t)
;; (load-theme 'kaolin-bubblegum t)
;; (load-theme 'kaolin-eclipse t)
;; (load-theme 'kaolin-ocean t)
;; (load-theme 'kaolin-temple t)
;; (load-theme 'kaolin-eclipse t)
;; (load-theme 'kaolin-valley-dark t)
;; (load-theme 'gruvbox-dark-medium t)
;; (load-theme 'gruvbox-dark-hard t)
;;(load-theme 'gruvbox t)

;; (load-theme 'deeper-blue t)
;; (load-theme 'misterioso t)
;; (load-theme 'tango-dark t)
;; (load-theme 'tsdh-dark t)
;; (load-theme 'wheatgrass t)
;; (load-theme 'wombat t)

;; Quita toolbar
(tool-bar-mode -1)

;; Status bar
;; (use-package smart-mode-line :ensure t)
;; (sml/setup)
;; (setq sml/theme 'light)
;; (setq sml/theme 'dark)
;; (setq sml/theme 'respectful)
;; (use-package ergoemacs-status :ensure t)
;; (ergoemacs-status-mode)
;; (use-package spaceline :ensure t)
;; (spaceline-spacemacs-theme)
;; (use-package powerline :ensure t)
;; (powerline-default-theme)
;; (use-package symon :ensure t)
;; (symon-mode)
(use-package doom-modeline
  :ensure t
  :config
  ;; (setq doom-modeline-icon (display-graphic-p))
  ;; (setq doom-modeline-height 25)
  ;; (set-face-attribute 'mode-line nil :height 120)
  :init (doom-modeline-mode 1))
(defvar doom-modeline-icon (display-graphic-p))

;; Scroll Smooth
(use-package good-scroll :ensure t)
(good-scroll-mode 1)
(global-set-key [next] #'good-scroll-up-full-screen)
(global-set-key [prior] #'good-scroll-down-full-screen)

;; Iconos
(use-package vscode-icon
  :ensure t
  :commands (vscode-icon-for-file))

;; Theme looper
(use-package theme-looper :ensure t
  :config
  (global-set-key (kbd "M-<f9>")    'theme-looper-select-theme)
  (global-set-key (kbd "M-<f11>")   'theme-looper-enable-previous-theme)
  (global-set-key (kbd "M-<f12>")   'theme-looper-enable-next-theme))

;; (theme-looper-set-favorite-themes '(abyss ample-flat ample ancient-one-dark arc-dark arjen-grey atom-dark atom-one-dark avk-darkblue-yellow ayu-dark ayu-grey badger badwolf birds-of-paradise blackboard bliss boron brutalist-dark bubbleberry busybee calmer-forest caroline chocolate clues colonoscopy sanityinc-solarized-dark creamsody cyberpunk-2019 dakrone darcula dark-krystal dark-mint darkburn darkmine darkokai darktooth distinguished django dracula enlightened firecode flatland flatland-dark flatui foggy-night foggy-blue green-phosphor green-screen gruber-darker gruvbox-dark-hard gruvbox-dark-medium gruvbox-dark-soft gruvbox hamburg hc-zenburn hemisu-dark heroku idea-darkula immaterial-dark inkpot kaolin-aurora kaolin-bubblegum kaolin-dark kaolin-blossom kaolin-mono-dark kaolin-ocean kaolin-shiva kaolin-temple kaolin-valley-dark lavenderless leuven-dark liso lush madhat2r material mbo70s mellow metalheart minsk molokai monokai-pro-classic monokai-pro-machine monokai-pro-octagon monokai-pro-ristretto monokai-pro-spectrum monokai-pro monokai mustang mustard naquadah naysayer night-owl nimbus noctilux nord northcode nova nyx oceanic one-dark paganini panda peacock blurb purp purple-haze rebecca reverse reykjavik rimero seoul256 seti shades-of-purple snazzy base16-apathy base16-apprentice base16-ashes base16-atelier-cave base16-atelier-dune base16-atelier-estuary base16-atelier-lakeside base16-atelier-plateau base16-atelier-savada ~~~~~~~ wheatgrass wombat tsdh-dark tango-dark misterioso deeper-blue zweilight  zerodark zeno zenburn zen-and-art warm-night waher underwater undersea ujelly ubuntu twilight twilight-anti-bright toxi timu-spacegrey tangotango tango-2 sweet suscolors wilson spolsky odersky junio hickey granger graham foggy-night fogus dorsey brin subatomic256 subatomic spacemacs-dark sourcerer soothe solarized-zenburn))

;; badger heroku inkpot molokai

;; Numero de lineas TODO diferencia
;; (linum-mode)
;; (global-display-line-numbers-mode)
(column-number-mode)

;; Highlight busqueda
(setq lazy-highlight-cleanup nil)
(setq lazy-highlight-max-at-a-time nil)
(setq lazy-highlight-initial-delay 0)

;; Highlight Simbolos
(use-package highlight-symbol :ensure t
  :config
  (set-face-attribute 'highlight-symbol-face nil
                      :background "default"
                      :foreground "#FA009A")
  (setq highlight-symbol-idle-delay 0)
  (setq highlight-symbol-on-navigation-p t)
  (add-hook 'prog-mode-hook #'highlight-symbol-mode)
  (add-hook 'prog-mode-hook #'highlight-symbol-nav-mode)
  (add-hook 'emacs-lisp-mode-hook #'highlight-symbol-mode)
  (add-hook 'emacs-lisp-mode-hook #'highlight-symbol-nav-mode)
  (add-hook 'lisp-mode-hook #'highlight-symbol-mode)
  (add-hook 'lisp-mode-hook #'highlight-symbol-nav-mode))


;; Rainbow Delimiter (parentesis)
(use-package rainbow-delimiters :ensure t)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook #'rainbow-delimiters-mode)


;; (require 'paren)
;; (set-face-background 'show-paren-match (face-background 'default))
;; (set-face-foreground 'show-paren-match "#def")
;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;; Parentesis sueltos
;; (use-package flylisp :ensure t)

;; Rainbow Identifiers (variables)
(use-package rainbow-identifiers :ensure t)
(add-hook 'prog-mode-hook #'rainbow-identifiers-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-identifiers-mode)
(add-hook 'lisp-mode-hook #'rainbow-identifiers-mode)


;; Highlight Blocks
;; (use-package hl-block-mode :ensure t)
;; (setq hl-block-bracket nil)
;; (setq hl-block-delay 0)
;; (setq hl-block-color-tint "#EEEEEE")
;; (global-hl-block-mode)


;; Rainbow Blocks
;; (use-package rainbow-blocks :ensure t)
;; (add-hook 'prog-mode-hook #''rainbow-blocks-mode)
;; (add-hook 'emacs-lisp-mode-hook #'rainbow-blocks-mode)
;; (add-hook 'lisp-mode-hook #'rainbow-blocks-mode)

;; Rainbow Mode colores para codigos TODO hooks o global
(use-package rainbow-mode :ensure t)


;; Highlight TO DO
(use-package hl-todo :ensure t)
(global-hl-todo-mode)


;; Join lines
(defun top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'top-join-line)

(add-to-list 'load-path "~/.emacs.d/elpa/clede/")
(use-package clede
  :init
  (let* ((system-file (expand-file-name "system.lisp" "~/git/ravenpack"))
         (ram-file (expand-file-name "system.lisp" "/mnt/ram/git/ravenpack")))
    (setq clede-commands-list
          `(("Recompile MC" .
             ,(format
               "(macrolet ((find-and-invoke (name)
                          `(let ((restart (find-restart ,name)))
                             (when restart
                               (invoke-restart restart)))))
               (handler-bind
                   ((error (lambda (condition)
                             (declare (ignore condition))
                             (find-and-invoke 'continue)
                             (find-and-invoke 'unintern))))
                 (load-system :dms-base :compile t)))" system-file))
            ("Start MC gen5" .
             ,(format
               "(load  \"%s\")
(excl:clean-system :mis.management-console)
(excl:load-system :mis.management-console :compile t)
(mc:start-application :management-console :environment :development :variant :gen5-only)
(setf dbu:*db-cache-dir* nil)" system-file))
            ("Start MC gen5 RAM" .
             ,(format
               "(load  \"%s\")
excl:clean-system :mis.management-console)
(excl:load-system :mis.management-console :compile t)
(mc:start-application :management-console :environment :development :variant :gen5-only)
(setf dbu:*db-cache-dir* nil)" ram-file))
            ("Pretty Print" .
             "slynk::(setf slynk::*slynk-pprint-bindings*
                           `((*print-pretty*           . t)
                             (*print-level*            . nil)
                             (*print-length*           . nil)
                             (*string-elision-length*  . nil)
                             (*print-circle*           . nil)
                             (*print-gensym*           . t)
                             (*print-readably*         . nil)))")
            ("Start DS" .
             ,(format "(progn (load \"%s\")
(excl:clean-system :mis.dataset-server)
(excl:load-system :mis.dataset-server :compile t) )"
                      system-file))
            ("Launch DSS API" .
             "(progn (dss::start-application :dataset-server-gen4 :port 9091
:load-resources nil :log-to-slack-p nil :environment :default :variant :Default :force-p t)
(setf dss::*skip-analytics-check* t))"))))
  :config
  ;; (define-key clede-minor-mode-map [escape] 'imenu-list-quit-window)
  ;; (define-key clede-minor-mode-map [escape] 'delete-window)
  (clede-start)
  (semantic-mode)
  (bind-key [f12] 'imenu-list-minor-mode))


;; Tramp
(setq sly-contribs (list 'sly-fancy
                         ;; 'sly-tramp
                         'sly-scratch
                         ;;'sly-macrostep
                         'sly-indentation))

(sly-setup)

(when (string-equal system-type "windows-nt")
  (add-to-list 'sly-filename-translations
               (sly-create-filename-translator
                :machine-instance "garm"
                :remote-host "garm.local"
                :username "kael")))


;; Ruler linea 80
(require 'whitespace)
(setq whitespace-line-column 90) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)
;; (add-hook 'window-configuration-change-hook (lambda () (ruler-mode 1)))
;; (add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; History for Sly
(defun helm-sly-mrepl-history()
  (interactive)
  (or (and (fboundp 'helm) (string-equal major-mode "sly-mrepl-mode")
	   (let* ((helm-source-sly-mrepl
		   (helm-build-sync-source "sly-mrepl"
		     :candidates (ring-elements comint-input-ring)
		     :action '(("Insert" . (lambda (selected) (insert selected)))))))
	     (helm :sources (list  helm-source-sly-mrepl)
		   :buffer "*helm sly-mrepl*")
	     t))
      (message "Buffer major mode not valid")))
(define-key sly-mrepl-mode-map (kbd "C-r") 'helm-sly-mrepl-history)

;; So that M-. will work correctly.
;; (setq sly-filename-translations
;;       (list
;;        (sly-create-filename-translator
;;         :machine-instance "mc-1" ;; The value of (machine-instance) on the remote lisp.
;;         :remote-host "mc-1.local" ;; The hostname of the machine running it.
;;         :username "cmoore"))) ;; Your username.

;; I also heartily recommend setting this as it holds open
;; an ssh connection to the other end, vs. scp which needs to
;; re-establish the connection each time.

;; (use-package helm-sly
;;   :ensure t)
;; (global-helm-sly-mode)
;; (add-hook 'sly-mrepl-hook #'helm-sly-disable-internal-completion)
;; (setq helm-completion-in-region-fuzzy-match t)

(use-package visual-regexp :ensure t)
(bind-key "C-r" 'vr/replace)
;; (bind-key "C-S-f" 'vr/query-replace)
;; (use-package visual-regexp-steroids :ensure t)
;; (bind-key "C-r" 'vr/replace)


;; Preguntar por Ivy TODO
;; TODO Preguntar isearch guardar busqueda o historial
;; TODO Busqueda regedit
;; TODO Company indentar sobreescrito
;; TODO Company abrir autocompletado
;; TODO global-set-key dentro de los plugins
;; TODO sobreescrito mark set alt+s

;; TODO Company con palabras usadas en CL
;; TODO Multi-cursores
(put 'downcase-region 'disabled nil)

;; Font
;;(add-to-list 'default-frame-alist '(font . FONT ))
;;(set-face-attribute 'default t :font FONT )


;; Shorcuts
;; Comentarios
(global-set-key (kbd "C-+")       'comment-line)
;; Ventanas
(global-set-key (kbd "M-!")       'delete-other-windows)
(global-set-key (kbd "M-\"")      'split-window-below)
(global-set-key (kbd "M-#")       'split-window-right)
(bind-key "M-$" 'delete-window)

(global-set-key (kbd "C-!")       'delete-other-windows)
(global-set-key (kbd "C-\"")      'split-window-below)
(global-set-key (kbd "C-#")       'split-window-right)
(global-set-key (kbd "C-$")       'delete-window)
;; Cambio buffers
(global-set-key (kbd "<mouse-8>") 'previous-buffer)
(global-set-key (kbd "<mouse-9>") 'next-buffer)
;; Movimiento
(global-set-key (kbd "<M-up>")    'backward-paragraph)
(global-set-key (kbd "<M-down>")  'forward-paragraph)
;; Eval
(global-set-key (kbd "<f10>")    'eval-buffer)
(global-set-key (kbd "<S-f10>")  'eval-last-sexp)
(global-set-key (kbd "<C-f10>")  'describe-variable)
;; Identacion
(global-set-key (kbd "<backtab>") 'indent-region)
;; Cerrar ventana
(global-set-key (kbd "C-w")       'delete-window)
;; Describe key
(global-set-key (kbd "C-\\")      'describe-key)
;; Escape C-g
;; (global-set-key (kbd "<ESC>")      'keyboard-escape-quit)
;; (global-set-key (kbd "<ESC>"      'keyboard-quit))
;; (define-key key-translation-map (kbd "ESC") (kbd "C-g"))
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
;; Open config
(bind-key "C--" (lambda () (interactive) (find-file user-init-file)))

;; Cut lines
;; https://pragmaticemacs.wordpress.com/2015/05/08/cut-whole-line/
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))
;; Change definition navigation
;; (bind-key "C-." 'xref-find-definitions)
;; (bind-key "C-," 'xref-pop-marker-stack)

;; Blink diferentes colores
;; (defvar blink-cursor-colors (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  ;; "On each blink the cursor will cycle to the next color in this list.")
;; (setq blink-cursor-count 0)
;; (defun blink-cursor-timer-function ()
;;   "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'.
;; Warning: overwrites original version in `frame.el'.
;; This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
;;   (when (not (internal-show-cursor-p))
;;     (when (>= blink-cursor-count (length blink-cursor-colors))
;;       (setq blink-cursor-count 0))
;;     (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
;;     (setq blink-cursor-count (+ 1 blink-cursor-count))
;;     )
;;   (internal-show-cursor nil (not (internal-show-cursor-p))))

;; Caret cursor
;; (setq cursor-type '(bar . 5))
;; (setq cursor-type 'box)
;; (blink-cursor-mode 1)
(set-cursor-color "#ffff00")
(setq blink-cursor-interval .15)
(setq cursor-type 'hollow)

(setq evil-emacs-state-cursor '("yellow" box))
;; (setq evil-normal-state-cursor '("firebrick" box))
(setq evil-normal-state-cursor '("yellow" hollow))
(setq evil-visual-state-cursor '("cyan" box))
(setq evil-insert-state-cursor '("cyan" box))
(setq evil-replace-state-cursor '("red" box))
(setq evil-operator-state-cursor '("yellow" box))

;; (set-face-attribute 'bold nil :font "Consolas Ligaturized" :height 160)
;; (set-frame-font "Consolas Ligaturized" nil t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "ConsolasLigaturized Nerd Font" :foundry "MS  " :slant normal :weight bold :height 160 :width normal :antialias=natural)))))
