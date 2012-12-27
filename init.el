;;----------------------------------------------------------------
;; Emacs init file by Bertrand
;;----------------------------------------------------------------

;;----------------------------------------------------------------
;; Cheatsheet

;; to load this file run eval-buffer

;; Comment editing
;; M-q

;; Aller à la ligne <line number>
;; M-g g <line number> RET :

;; Autocompletion
;; M-C /

;; Suprimer jusqu'au caractère <c> :
;; M-z <c>

;; Remplacer
;; %-%

;; Gestion de versions
;; C-x v (v/~/l/=)

;; Rectangle
;; C-x r k(couper)/y(coller)/t(inserer)

;; Macro
;; début C-x (
;; fin C-x )
;; exécuter C-x e

;; Tags (acces direct à code d'une autre fonction)
;; lancer etags *.c *.h
;; Dans emacs, se positionner sur le début de la fonction :
;; M-. ou C-x 4 . (dans une autre fenetre)

;;----------------------------------------------------------------
;; Set up package manager and download missing packages

(require 'package)
(setq package-list '(ggtags company)) ;; list of required packages

(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;----------------------------------------------------------------
;; ggtags

(require 'ggtags)
(add-hook 'c-mode-common-hook
		  (lambda ()
			(when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
			  (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

;;----------------------------------------------------------------
;; company

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;;(add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8/")


;;----------------------------------------------------------------
;; Key binding

(global-set-key "\^x\^c"  'compile)
(global-set-key "\^z"  'undo)
(global-set-key "\^xc"   'comment-or-uncomment-region)
(global-set-key (kbd "C-c u") 'whitespace-cleanup)

(global-set-key [f1] `delete-other-windows)
(global-set-key [f2] `split-window-horizontally)
(global-set-key [f3] `enlarge-window-horizontally)
(global-set-key [f4] `split-window-vertically)
(global-set-key [f5] `enlarge-window)
(global-set-key [f6] `delete-window)

;; Supprime ce qui est à gauche du curseur
(defun backward-kill-line ()
   "Kill backward from point to beginning of line"
   (interactive) (kill-line 0))
(global-set-key [M-backspace] 'backward-kill-line)
(global-set-key [?\C-x C-backspace] 'backward-kill-line)

;;----------------------------------------------------------------
;; Display

;; Maximum syntax colorization in all modes
(require 'font-lock)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Taille par défaut de la fenêtre. Pour ajouter un
;; positionnement (en pixels), il faut saisir la ligne suivante :
;; (setq initial-frame-alist '((width . 100) (height . 60)))
(setq initial-frame-alist
	  '((top . 1) (left . 1) (width . 80) (height . 34)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (company company-c-headers sr-speedbar ggtags)))
 '(tool-bar-mode nil nil (tool-bar)))

;; Interdire le "fill-mode" qui casse les lignes automatiquement
(setq-default auto-fill-mode nil)

;; Empecher de tronquer les lignes trop longues
(setq truncate-partial-width-windows nil)

;; Ne pas afficher la barre de scrolling
(set-scroll-bar-mode nil)

;; afficher la date au format 24h
(setq display-time-24hr-format t)
(display-time)

;; Afficher les numeros de colonnes et des lignes
(column-number-mode t)
(line-number-mode t)

;; Afficher le nom du fichier dans la barre de titre de la fenetre
(setq frame-title-format '(buffer-file-name "%b [%f]" "%b"))

;; Chagement du theme (Choix si emacs-goodies-el est installé)

;; Chagement du theme (Sinon)
;;(set-face-background 'default "black")
;;(set-foreground-color "white")
;;(set-cursor-color "white")
;;(set-mouse-color "white")

;; Pour que la region selectionnee soit mise en surbrillance
(transient-mark-mode 1)

;; Pour que la fenetre de compilation ne soit pas trop grande
(setq compilation-window-height 10)

;; Show matching brackets
(show-paren-mode 1)
(setq show-paren-delay 0)

;;----------------------------------------------------------------
;; Configure mode

(setq-default indent-tabs-mode nil)

;; Gestion des buffers, déplacement avec C-r/C-s
(icomplete-mode 99)
(iswitchb-mode t)

;; Configuration for java
(add-hook 'java-mode-hook (lambda ()
							(setq indent-tabs-mode nil)
							(setq c-basic-offset 4)))

;; Configuration pour le C/C++
(setq c-default-style '((c-mode . "linux")(c++-mode . "linux")))

(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.frag$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.vert$" . c++-mode) auto-mode-alist))
(setq c-basic-offset 4)

(setq c-mode-hook
	(function (lambda ()
				(setq indent-tabs-mode nil)
				(setq c-indent-level 4))))

(setq c++-mode-hook
	(function (lambda ()
				(setq indent-tabs-mode nil)
				(setq c-indent-level 4))))

;; Ouverture automatique du verilog mode pour les .sv
(setq auto-mode-alist (cons '("\\.sv$" . verilog-mode) auto-mode-alist))

;;----------------------------------------------------------------
;; Other

;; It is tedious to type "yes" to confirm, shorten it to 'y' (ditto for
;; "no" now "n").
(fset 'yes-or-no-p 'y-or-n-p)

;; Remove the backup files when quitting (you know, these famous
;; files whose names end with "~") .
;; (setq make-backup-files nil)

;; Tell Emacs to make backups by copying the old contents to a new
;; file and saving the new contents to the same file anytime a file
;; has more than one filename. Hardlink protect !!
(setq backup-by-copying-when-linked t)

;; When you enter text while a zone is selected, it is overwritten by
;; the text.
(delete-selection-mode 1)

;; Default tab width
(setq default-tab-width 4)

;; Conserver les fichiers backups (nom du fichier suivi d'un ~) dans le
;; repertoire indiqué
(defvar backup-dir "~/.emacs.d/backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Definir le dictionnaire francais par defaut (penser a installer le paquet
;; aspell-fr pour avoir le dictionnaire francais installe sous Ubuntu
(setq-default ispell-local-dictionary "francais")
(setq-default ispell-extra-args '("--reverse"))

;; Supprimer le bip
(setq ring-bell-function 'ignore)

;; Autocompletion avec la touche tab
(global-set-key [(tab)] 'smart-tab)
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
(put 'scroll-left 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
