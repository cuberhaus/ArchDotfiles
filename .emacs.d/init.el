;; The default is 800 kilobytes.  Measured in bytes.
(defvar last-file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold 402653184
    gc-cons-percentage 0.6
    file-name-handler-alist nil)

(setq use-package-verbose t) ;; debug to see which packages load, and maybe shouldn't, should be off

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Initialize package sources
(require 'package) ; bring in package module
; package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize) ; Initializes package system
(unless package-archive-contents ; unless package exists we refresh package list
 (package-refresh-contents)) 

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package) ; is this package installed, unless its installed install it
   (package-install 'use-package))
(require 'use-package)

(setq use-package-always-ensure t) ;; equivalent to writing :ensure t in all packages
;; makes sure that package is downloaded before use

;; You will most likely need to adjust this font size for your system!
    (defvar runemacs/default-font-size 110)

    (setq inhibit-startup-message t) ; Disable startup menu
    (scroll-bar-mode -1) ; Disable the scrollbar
    (tool-bar-mode -1)
    ;(tooltip-mode -1) disable tooltips ;; (text displayed when hovering over an element)
    (set-fringe-mode 10) ; Make some space
    (menu-bar-mode -1) ;; remove top bar
    (cond ((eq system-type 'windows-nt)
        ;; Windows-specific code goes here.
        )
          ((eq system-type 'darwin)
              (setq ring-bell-function ;; subtle mode line flash
                  (lambda ()
                      (let ((orig-fg (face-foreground 'mode-line)))
                      (set-face-foreground 'mode-line "#F2804F")
                      (run-with-idle-timer 0.1 nil
                                          (lambda (fg) (set-face-foreground 'mode-line fg))
                                          orig-fg))))
        )
        ((eq system-type 'gnu/linux)
         (setq visible-bell t)
        ))

    ;; (setq scroll-step            1
    ;;     scroll-conservatively  10000) ;; scroll line by line not like a fucking degenerate
    ;; (setq smooth-scroll-margin 4) ;; margin like in vim
;;
;;; Scrolling

(setq hscroll-margin 2
      hscroll-step 1
      ;; Emacs spends too much effort recentering the screen if you scroll the
      ;; cursor more than N lines past window edges (where N is the settings of
      ;; `scroll-conservatively'). This is especially slow in larger files
      ;; during large-scale scrolling commands. If kept over 100, the window is
      ;; never automatically recentered.
      scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)


    (setq vc-follow-symlinks t) ;; always follow symlinks
    (column-number-mode)
    (global-display-line-numbers-mode t) ;; display line numbers everywhere
    ;; (setq vc-follow-symlinks nil) ;; or never follow them

  (defun efs/display-startup-time ()
    (message "Emacs loaded in %s with %d garbage collections."
             (format "%.2f seconds"
                     (float-time
                     (time-subtract after-init-time before-init-time)))
             gcs-done))

  (add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Font Configuration -----------------------
  ;; (set-face-attribute 'default nil :font "SauceCodePro Nerd Font 11")
  ;; IF FONT LOOKS WEIRD (TOO SLIM) then it means the font is not working properly, CHANGE IT

(cond ((eq system-type 'windows-nt)
    ;; Windows-specific code goes here.
    )
      ((eq system-type 'darwin)
      (set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 170)

      ;; Set the fixed pitch face
      (set-face-attribute 'fixed-pitch nil :font "FiraCode Nerd Font" :height 180)

      ;; Set the variable pitch face
      (set-face-attribute 'variable-pitch nil :font "Cantarell" :height 180 :weight 'regular)
    )
    ((eq system-type 'gnu/linux)
      (set-face-attribute 'default nil :font "FuraCode Nerd Font" :height runemacs/default-font-size)

      ;; Set the fixed pitch face
      (set-face-attribute 'fixed-pitch nil :font "FuraCode Nerd Font" :height 120)

      ;; Set the variable pitch face
      (set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 120 :weight 'regular)
    ))
  ;; -------------------------------------------------------

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 4)
;; (setq indent-line-function 'insert-tab)

;(use-package command-log-mode)

(setq x-select-enable-clipboard-manager nil); weird emacs bug where it won't close

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-auto-revert-mode) ;;

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook
                shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0 ))))

;; (use-package langtool)

;; has to install pdf2svg on pc first
;; (use-package org-inline-pdf
;;   :init
;;   (add-hook 'org-mode-hook #'org-inline-pdf-mode))

(setq langtool-java-classpath
      "/usr/share/languagetool:/usr/share/java/languagetool/*")
    (use-package langtool
      :commands langtool-check)

;; execute spanish spell-checking on buffer
      (defun flyspell-spanish ()
        (interactive)
        (ispell-change-dictionary "castellano")
        (flyspell-buffer))

      (defun flyspell-english ()
        (interactive)
        (ispell-change-dictionary "default")
        (flyspell-buffer))
(use-package flycheck
  :commands (flycheck-mode global-flycheck-mode)
    :ensure t
    ;; :init (global-flycheck-mode)
    )
  (use-package flycheck-popup-tip
    :after flycheck)
  (with-eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package eyebrowse
  :ensure t
  :init
  (global-unset-key (kbd "C-c C-w"))
  (setq eyebrowse-keymap-prefix (kbd "C-a")) ;; we have to set this before the package is initialized  https://github.com/wasamasa/eyebrowse/issues/49
  (setq eyebrowse-new-workspace t) ; by default nil, clones last workspace, set to true shows scratch
  :config
  (eyebrowse-mode t)
  )

(winner-mode 1)

;; (desktop-save-mode 1)

;; use only one desktop
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")

;; remove desktop after it's been read
;; (add-hook 'desktop-after-read-hook
;;           '(lambda ()
;;              ;; desktop-remove clears desktop-dirname
;;              (setq desktop-dirname-tmp desktop-dirname)
;;              (desktop-remove)
;;              (setq desktop-dirname desktop-dirname-tmp)))

(defun saved-session ()
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; use session-restore to restore the desktop manually
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No desktop found.")))

;; use session-save to save the desktop manually
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
          (desktop-save-in-desktop-dir)
        (message "Session not saved."))
    (desktop-save-in-desktop-dir)))

;; ask user whether to restore desktop at start-up
;; (add-hook 'after-init-hook
;;           '(lambda ()
;;              (if (saved-session)
;;                  (if (y-or-n-p "Restore desktop? ")
;;                      (session-restore)))))

;; (add-hook 'kill-emacs-hook '(lambda ()
;;                              (if (y-or-n-p "Save desktop? ")
;;                               (desktop-save-in-desktop-dir))
;;                              ))

(use-package ivy ; makes navigation between stuff easier
  :diminish ; do not show stuff on bar or something
  :bind (("C-s" . swiper) ;;like / but with context
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
;; eval last sexp is better cause inconsistencies from hooks when running evalbuffer
;; and show keybindings

(use-package ivy-rich ;; shows better explanations
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel ;; must have this
  ;; :custom
  ;; (ivy-prescient-enable-filtering nil) ;; keep ivy filtering style
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1)
  )
;; (setq prescient-filter-method '(fuzzy regexp))
(setq prescient-sort-length-enable nil) ;; do not sort by length

(use-package company-prescient
:after company
:config
(company-prescient-mode 1))

;; With ivy-rich shows descriptions for commands 
(use-package counsel
:bind (("M-x" . counsel-M-x)
        ("C-x b" . counsel-ibuffer)
        ("C-x C-f" . counsel-find-file)
        :map minibuffer-local-map
        ("C-r" . 'counsel-minibuffer-history))
        :config
        (setq ivy-initial-inputs-alist nil))

(use-package all-the-icons)
;; custom command line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
(use-package doom-themes) ;; counsel-load-theme to load a theme from the list
(load-theme 'doom-one t) ;; if not using t will prompt if its safe to https://github.com/Malabarba/smart-mode-line/issues/100

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer) ;; easier command to switch buffers
  ;; example (define-key emacs-lisp-mode-map (kbd "C-x M-t") 'counsel-load-theme) define keybinding only in emacs-lisp-mode

(use-package general ;; set personal bindings for leader key for example
 ; (general-define-key "C-M-j" 'counsel-switch-buffer) ;; allows to define multiple global keybindings
  ;; :after evil
  :config
  (general-create-definer rune/leader-keys
  :keymaps '(normal insert visual emacs)
  :prefix "SPC" 
  :global-prefix "C-SPC") ;; leader
  (rune/leader-keys ;; try to have similar keybindings in vim as well
   "s" '(:ignore s :which-key "session") ;; "folder" for toggles
   "ss" '(session-save :which-key "session save") ;; "folder" for toggles
   "sr" '(session-restore :which-key "session restore") ;; "folder" for toggles
   "t" '(:ignore t :which-key "toggles") ;; "folder" for toggles
   "v" '(:ignore v :which-key "terminal") ;;
   "vv" '(vterm-toggle :which-key "toggle vterm") ;; "folder" for toggles
   "vc" '(vterm-toggle-cd :which-key "toggle vterm on current folder") ;; "folder" for toggles
   "b" '(:ignore b :which-key "buffers") 
   "h" '(:ignore h :which-key "git-gutter") 
   "c" '(org-capture :which-key "org-capture") ;; this is F*** awesome
   "g" '(git-gutter-mode :which-key "git-gutter toggle") 
   "hn" '(git-gutter:next-hunk :which-key "next hunk") 
   "hp" '(git-gutter:previous-hunk :which-key "previous hunk") 
   "hv" '(git-gutter:popup-hunk :which-key "preview hunk") 
   "hs" '(git-gutter:stage-hunk :which-key "stage hunk") 
   "hu" '(git-gutter:revert-hunk :which-key "undo hunk") ;; take back changes
   "hg" '(git-gutter :which-key "update changes") 
   "o" '(buffer-menu :which-key "buffer menu") 
   "bn" '(evil-next-buffer :which-key "next buffer") 
   "bp" '(evil-prev-buffer :which-key "previous buffer")
   "bc" '(evil-delete-buffer :which-key "close buffer")
   "bd" '(delete-file-and-buffer :which-key "delete file")
   "w" '(save-buffer :which-key "save buffer") ;; classic vim save
   "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package hydra
    :defer t) ;; emacs bindings that stick around like mode for i3

  (defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("q" nil "finished" :exit t))
  (rune/leader-keys
    "ts" '(hydra-text-scale/body :which-key "scale text"))

  (rune/leader-keys
    "tr" '(window-resize-hydra/body :which-key "resize windows"))

  (defhydra window-resize-hydra (:hint nil)
  "
             _k_ increase height
_h_ decrease width    _l_ increase width
             _j_ decrease height
"
  ("h" evil-window-decrease-width)
  ("j" evil-window-increase-height)
  ("k" evil-window-decrease-height)
  ("l" evil-window-increase-width)

  ("q" nil))

;; vim keybindings for easier on the fingers typing :D
(use-package evil
  :init
  (setq evil-want-integration t) ;; must have
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;(define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line) ;; both of these
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line) ;; are needed for org mode where g-j doesn't work properly

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
;; to center screen on cursor, zz or emacs-style C-l

;; https://github.com/linktohack/evil-commentary
;; use-package makes it so that it installs it from config and config section
;; activates the mode
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-collection
  :after evil ;; load after evil, must have
  :config
  (evil-collection-init))

; C-z go back to EMACS MODE

(use-package evil-goggles
  :ensure t
  :after evil
  :config
  (evil-goggles-mode)

  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))

(use-package which-key ;; This shows which commands are available for current keypresses
  :commands(helpful-callable helpfull-variable helpful-command helpful-key)
  :defer 0
  ;; runs before package is loaded automatically whether package is loaded or not we can also invoke the mode
  :diminish which-key-mode
  :config ;; this is run after the package is loaded
 (which-key-mode)
  (setq which-key-idle-delay 0.15)) ;; delay on keybindings 

(use-package helpful ;; better function descriptions
  :custom ;; custom variables
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function) ;; remap keybinding to something different
  ([remap describe-command] . helpful-command) 
  ([remap describe-variable] . counsel-describe-variable))

(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
              (delete-file filename)
              (message "Deleted file %s." filename)
              (kill-buffer)))
      (message "Not a file visiting buffer!"))))

(with-eval-after-load 'org
    (require 'org-tempo)
    (add-to-list 'org-structure-template-alist '("py" . "src python"))
    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("hs" . "src haskell"))
    (add-to-list 'org-structure-template-alist '("cpp" . "src C++"))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    )

(use-package haskell-mode
  :after (org lsp) ) ;; needed for haskell snippets

(with-eval-after-load 'org
    (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        (java . t)
        (python . t)))
    (push '("conf-unix" . conf-unix) org-src-lang-modes)
    )

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))) ;; replace - in lists for a dot

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2) ;; variable sizes for headers
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "DejaVu Sans" :weight 'regular :height(cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch)) ;; fixed pitch on some stuff so that it lines up correctly, and variable on others so that it looks better
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1) ;; allows text to be of variable size
  (visual-line-mode 1) ;; makes emacs editing commands act on visual lines not logical ones, also word-wrapping, idk if i want this
  )

(use-package org  ;; org is already installed though
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (message "Org mode loaded")
  (setq org-ellipsis " ▾") ;; change ... to another symbol that is less confusing
  (efs/org-font-setup) ;; setup font
   ;; hides *bold* and __underlined__ and linked words [name][link]
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time) ;; logs when a task goes to done C-h-v (describe variable)
  (setq org-log-into-drawer t) ;; collapse logs into a drawer
  (setq org-agenda-files
        '("~/fib/org/birthday.org"
          "~/fib/org/Tasks.org"
          "~/fib/org/Habits.org"
          ))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit) ;;  add org-habit to org-modules
  (setq org-habit-graph-column 60) ;; what column the habit tracker shows

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets ;; move TODO tasks to a different file
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

 (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/fib/org/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/fib/org/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/fib/org/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/fib/org/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/fib/org/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  )

;; (defun efs/org-mode-visual-fill ()
;;   (setq visual-fill-column-width 100 ;; set column width (character width?)
;;         visual-fill-column-center-text t) ;; center text on middle of screen
;;   (visual-fill-column-mode 1))

;; (use-package visual-fill-column
;;   :hook (org-mode . efs/org-mode-visual-fill))

(use-package org-bullets ;; changes headers so that it doesn't show all of the stars
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))) ;; default symbols get weird

;; (use-package org-fragtog
;; :after org-bullets
;; :hook (org-fragtog) ; this auto-enables it when you enter an org-buffer, remove if you do not want this
;; :config
;; (org-fragtog-mode)
;; ;; whatever you want
;; )

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/dotfiles/dotfiles/.org/babel.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config))) ;; add hook to org mode

(use-package smartparens
    :config
    (require 'smartparens-config)
    (smartparens-global-mode t)
    (smartparens-global-strict-mode t)
    )
;; (add-hook 'js-mode-hook #'smartparens-mode)
;; (add-hook 'c++-mode-hook #'smartparens-mode)

(use-package evil-smartparens
    :after (smartparens)
    )
(add-hook 'smartparens-enabled-hook #'evil-smartparens-mode) ;; enable evil smartparens when smartparents is up
(add-hook 'smartparens-enabled-hook #'sp-use-smartparens-bindings) ;; enable smartparens keybindings

(global-set-key (kbd "M-f") #'ian/format-code)
  (defun ian/format-code ()
    "Auto-format whole buffer."
    (interactive)
    (if (derived-mode-p 'prolog-mode)
        (prolog-indent-buffer)
      (format-all-buffer)))
(use-package format-all
  :commands (format-all-buffer)
  :config
  (add-hook 'prog-mode-hook #'format-all-ensure-formatter))

  ;; (setq format-all-formatters (("LaTeX" latexindent)))

(use-package clips-mode
  :mode "\\.clp\\'"
  )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ;; prog-mode is based mode for any programming language

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)) ;; give description for keys with wichkey

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-doc-position 'bottom))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")'
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))
(use-package lsp-treemacs
      :after lsp)

(use-package lsp-ivy
  :after (lsp-mode lsp))

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :after lsp
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package lsp-haskell
  :hook (haskell-mode . lsp-deferred)
  )

(use-package ccls
  :hook (c-mode c++-mode objc-mode))

(use-package lsp-java
  :hook (java-mode . lsp-deferred))

(use-package latex-preview-pane
    :hook (latex-mode . latex-preview-pane-mode)
  )

;; (use-package tex
;;   :ensure auctex)
;;    (setq TeX-auto-save t)
;;   (setq TeX-parse-self t)
;;   (setq-default TeX-master nil)

;;   (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;;   (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;   (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;;   (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;;   (setq reftex-plug-into-AUCTeX t)

;; (use-package latex-mode
;;   :ensure t
;;   :hook (latex-mode . lsp-deferred)
;;   (add-hook 'latex-mode 'lsp-deferred)
;;   )

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; bring in the GIT
;; use C-x g to open magit status
;; type ? to know what can you do with magit
(use-package magit ;; use tab to open instead of za in vim
  :commands magit-status
  ;; :custom
  ;;   (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  )

;; emacs variables local to projects
(use-package projectile ;; git projects management
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy)) ;; use ivy for completion can also use helm
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/")
    (setq projectile-project-search-path '("~/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile ;; more commands with M-o in projectile (ivy allows that)
  :after projectile
  :config(counsel-projectile-mode))

(use-package git-gutter ;; works just like in vim :D
  :commands (git-gutter-mode git-gutter)
  :config
  ;; If you enable global minor mode
  ;; (global-git-gutter-mode t)
  ;; If you enable git-gutter-mode for some modes
  (add-hook 'ruby-mode-hook 'git-gutter-mode)
  )

;; (use-package diff-hl
;;   :init
;;   (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
;;   (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
;;   :config
;;   (global-diff-hl-mode)
;;   (diff-hl-margin-mode)
;;   )
;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
;; (use-package forge) ;; more git functionality

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "zsh") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

;; (use-package vterm-toggle)
;; (global-set-key [M-t] 'vterm-toggle-cd)
;; (global-set-key [C-f2] 'vterm-toggle)

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))
  ;; (eshell-git-prompt-use-theme 'powerline)
  )

(use-package dired
  :ensure nil ;; make sure package manager doesn't try to install
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump));; doesn't open new buffers like classic jump

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh") ;; use programs for file extensions
                                ("mkv" . "mpv"))))
(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions)) ;; do not query to kill the buffer

;; after startup, it is important you reset this to some reasonable default. A large 
;; gc-cons-threshold will cause freezing and stuttering during long-term 
;; interactive use. I find these are nice defaults:
  (setq gc-cons-threshold 16777216
        gc-cons-percentage 0.1
        file-name-handler-alist last-file-name-handler-alist)
