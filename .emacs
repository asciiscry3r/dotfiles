(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes '(manoj-dark))
 '(display-battery-mode t)
 '(display-line-numbers-type 'visual)
 '(display-time-mode t)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages '(## rainbow-mode pdf-tools yaml-mode magit))
 '(scroll-bar-mode nil)
 '(size-indication-mode t)
 '(tool-bar-mode nil))

require 'server)
(unless (server-running-p)
  (server-start))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-prettify-symbols-mode 1)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode 1)))
(global-rainbow-mode 1)

(add-to-list 'global-mode-string '(" %i"))
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
