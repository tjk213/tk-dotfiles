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

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;;
;; General config
;;

(setq column-number-mode t)

;;
;; C/C++ Config
;;

(setq c-default-style "bsd"
      c-basic-offset 4)
