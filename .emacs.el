(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(let ((default-directory "~/.emacs.d/elpa/"))
    (normal-top-level-add-subdirs-to-load-path))

(require 'helm-projectile)
(require 'projectile)
(require 'rust-mode)
(require 'company-racer)
(require 'company)
(require 'dired)
(require 'yasnippet)
(require 'irony)
(require 'company-irony)
(require 'irony-snippet)
(require 'ido)
(require 'org)
(require 'company-c-headers)
(require 'company-statistics)
(require 'tabbar)

(yas-global-mode 1)
(setq company-racer-rust-src "/home/zhenyok/Programming/projects/rust/src")
(setq company-racer-executable "/home/zhenyok/Programming/racer-master/target/debug/racer")
;; (add-to-list 'load-path "<path-to-racer>/editors")

(defun mycfg-set-rust-backend ()
  (set (make-local-variable 'company-backends) '(company-racer))
)

(defun mycfg-set-c-backend ()
  (set (make-local-variable 'company-backends) '(company-irony company-abbrev))
  (irony-cdb-autosetup-compile-options)
)

(defun my-term-setup-hook()
  (define-key input-decode-map "\e[33~" (kbd "M-<DEL>")))
;  (define-key input-decode-map "\e[3~" (kbd "M-<DEL>")))

(defun mycfg-set-python-hook ()
  (set (make-local-variable 'company-backends) '(company-jedi company-abbrev))
  )

(defun mycfg-lisp-hook ()
  (set (make-local-variable 'company-backends) '(company-elisp company-abbrev))
  )

(defun mycfg-projectile-hook ()
  (if (projectile-project-p)
      (progn
       (set (make-local-variable 'company-c-headers-path-user)
	     (let ((root1 (projectile-project-root)))
	       (list root1
		     (concat root1 "src")
		     (concat root1 "inc")
		     (concat root1 "include")))
	     )
	(set (make-local-variable 'irony-additional-clang-options) (list "-std=c++11"))
	)
    (progn
      (set (make-local-variable 'irony--compile-options) (list "-std=c++11" "-I/usr/include" "-I/usr/include/c++/5.2.0"))
      (set (make-local-variable 'company-c-headers-path-system)
	 (list "/usr/include"
	       "/usr/local/include"
	       "/usr/include/c++/5.2.0")
    )
      ))
  (add-to-list 'company-backends 'company-c-headers)
  )

(add-hook 'rust-mode-hook 'company-mode-on)
(add-hook 'c-mode-hook 'company-mode-on)
(add-hook 'c++-mode-hook 'company-mode-on)
(add-hook 'c-mode-common-hook 'company-mode-on)
;; adding hooks
(add-hook 'tty-setup-hook 'my-term-setup-hook)
(add-hook 'projectile-mode-hook 'mycfg-projectile-hook)
(add-hook 'python-mode-hook 'mycfg-set-python-hook)
(add-hook 'rust-mode-hook 'mycfg-set-rust-backend)
(add-hook 'emacs-lisp-mode-hook 'mycfg-lisp-hook)
(add-hook 'c++-mode-hook 'mycfg-set-c-backend)
(add-hook 'c-mode-hook 'mycfg-set-c-backend)
(add-hook 'c-mode-common-hook 'mycfg-set-c-backend)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'after-init-hook 'company-statistics-mode)

(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;(global-auto-complete-mode t)


(projectile-global-mode)
(setq projectile-completion-system 'helm)
(setq org-agenda-include-diary t)

;; org-mode customization
(setq org-directory "~/Notes")
(setq org-agenda-files
      (list "~/Notes/home.org"
	    "~/Notes/sports.org"
	    "~/Notes/study.org"))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(global-set-key "\C-ca" 'org-agenda)
(global-set-key (kbd "M-DEL") 'backward-kill-word)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
