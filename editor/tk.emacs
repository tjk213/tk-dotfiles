;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               ,:                                                         ,:    ;;
;;             ,' |                                                       ,' |    ;;
;;            /   :                                                      /   :    ;;
;;         --'   /       :::::::::::   :::::::::::   :::    :::       --'   /     ;;
;;         \/ />/           :+:            :+:       :+:   :+:        \/ />/      ;;
;;         / /_\           +:+            +:+       +:+  +:+          / /_\       ;;
;;      __/   /           +#+            +#+       +#++:++         __/   /        ;;
;;      )'-. /           +#+            +#+       +#+  +#+         )'-. /         ;;
;;      ./  :\          #+#        #+# #+#       #+#   #+#         ./  :\         ;;
;;       /.' '         ###         #####        ###    ###          /.' '         ;;
;;     '/'                                                        '/'             ;;
;;     +                                                          +               ;;
;;    '                                                          '                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            Copyright © 2022 Tyler J. Kenney. All rights reserved.              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Init Packages
;;

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; FIXME: use-package doesn't work on coder
;;(when (not (package-installed-p 'use-package))
;;  (package-install 'use-package))
;;
;;(require 'use-package-ensure)
;;(setq use-package-always-ensure t)
;;
;;(use-package editorconfig
;;  :ensure t
;;  :config
;;  (editorconfig-mode 1))
;;
;;(use-package markdown-mode)

;; load editorconfig from submodule
(add-to-list 'load-path (concat (file-name-directory (file-truename load-file-name)) "../third-party/editorconfig-emacs"))
(require 'editorconfig)
(editorconfig-mode 1)

(add-to-list 'load-path (concat (file-name-directory (file-truename load-file-name)) "tk.emacs.d/modes"))

(load "tablegen-mode")
(load "llvm-mode")
(load "mlir-mode")
(load "dockerfile-mode")
(load "yaml-mode")
(load "graphviz-dot-mode")

;;
;; Display config
;;
;; NB: Older versions of this file installed solarized-theme via use-package and
;;     defaulted to solarized-light. Solarized-light is terrible but the package
;;     has lots of other themes, including some sort of solarized/wombat hybrid
;;     that was pretty good (still put comments in gray rather than dark red,
;;     however). See git history for details on how to set this up if necessary.
;;

(load-theme 'wombat t)      ;; Default theme = wombat
(setq column-number-mode t) ;; Always display column numbers!

;;; Uncomment below to clear theme-based background color.
;;; This sets up emacs to inherit background color from underlying terminal,
;;; which is great if we want to use a them to control font colors but an iterm
;;; profile to control the background. For now, we don't have any emacs theme
;;; enable at all, so we leave this commented as well.

;;(set-face-background 'default "undefined")


;; FIXME: use-package doesn't work on coder
;;(use-package beacon
;;  :config
;;  (beacon-mode 1))

;;
;; C/C++ Config
;;

(setq c-default-style "bsd"
      c-basic-offset 4)

(defun c-format-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'innamespace 0))

(add-hook 'c-mode-common-hook 'c-format-hook)

;;
;; Modular
;;

(let ((file (concat (getenv "MODULAR_PATH") "/utils/emacs/modular.el")))
  (when (file-exists-p file) (load-file file)))
