;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "ComicShannsMono Nerd Font" :size 18 )
      doom-variable-pitch-font (font-spec :family "ComicShannsMono Nerd Font" :size 18))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (load-theme 'catppuccin t t)
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


;; custom settings
(setq
 projectile-project-search-path '("~/code/"))

(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=3"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

(after! flyspell
  (setq flyspell-lazy-idle-seconds 2))
;;Flyspell will run a series of predicate functions to determine if a word should be spell checked.
(set-flyspell-predicate! '(markdown-mode gfm-mode)
  #'+markdown-flyspell-word-p)
(setq flyspell-default-dictionary "en_US")
(setq ispell-personal-dictionary "english")
;; enable word-wrap (almost) everywhere
(+global-word-wrap-mode +1)


;; djvu
(require 'djvu)
(require 'djvu3)

;;auto-save
(setq auto-save-visited-interval 5)
(auto-save-visited-mode +1)
;; (require 'auto-save)
;; (auto-save-enable)
;; (setq auto-save-silent t)
;; (setq auto-save-delete-trailing-whitespace t)
;; (setq auto-save-idle 0.1)

(after! evil-org
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))
;; codeium
;; we recommend using use-package to organize your init.el
;; (use-package codeium
;;   ;; if you use straight
;;   ;; :straight '(:type git :host github :repo "Exafunction/codeium.el")
;;   ;; otherwise, make sure that the codeium.el file is on load-path

;;   :init
;;   ;; use globally
;;   (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;   ;; or on a hook
;;   ;; (add-hook 'python-mode-hook
;;   ;;     (lambda ()
;;   ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

;;   ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;   ;; (add-hook 'python-mode-hook
;;   ;;     (lambda ()
;;   ;;         (setq-local completion-at-point-functions
;;   ;;             (list (cape-capf-super #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;   ;; an async company-backend is coming soon!

;;   ;; codeium-completion-at-point is autoloaded, but you can
;;   ;; optionally set a timer, which might speed up things as the
;;   ;; codeium local language server takes ~0.2s to start up
;;   (add-hook 'emacs-startup-hook
;;             (lambda () (run-with-timer 0.1 nil #'codeium-init)))
;;   ;; :defer t ;; lazy loading, if you want
;;   :config
;;   (setq use-dialog-box nil) ;; do not use popup boxes

;;   ;; if you don't want to use customize to save the api-key
;;   ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

;;   ;; get codeium status in the modeline
;;   (setq codeium-mode-line-enable
;;         (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;   (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;   ;; alternatively for a more extensive mode-line
;;   ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

;;   ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;   (setq codeium-api-enabled
;;         (lambda (api)
;;           (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;   ;; you can also set a config for a single buffer like this:
;;   ;; (add-hook 'python-mode-hook
;;   ;;     (lambda ()
;;   ;;         (setq-local codeium/editor_options/tab_size 4)))

;;   ;; You can overwrite all the codeium configs!
;;   ;; for example, we recommend limiting the string sent to codeium for better performance
;;   (defun my-codeium/document/text ()
;;     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;   ;; if you change the text, you should also change the cursor_offset
;;   ;; warning: this is measured by UTF-8 encoded bytes
;;   (defun my-codeium/document/cursor_offset ()
;;     (codeium-utf8-byte-length
;;      (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;   (setq codeium/document/text 'my-codeium/document/text)
;;   (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

;; ;; codeium-company
;; (use-package company
;;   :defer 0.1
;;   :config
;;   (global-company-mode t)
;;   (setq-default
;;    company-idle-delay 0.05
;;    company-require-match nil
;;    company-minimum-prefix-length 0

;;    ;; get only preview
;;    ;; company-frontends '(company-preview-frontend)
;;    ;; also get a drop down
;;    company-frontends '(company-pseudo-tooltip-unless-just-one-frontend company-preview-frontend)
;;    ))

(setq scroll-margin 10)
(setq hscroll-margin 10)


(after! evil

  ;;Resize Window
  (evil-define-key 'normal 'global
    (kbd "C-<left>") 'evil-window-decrease-width
    (kbd "C-<right>") 'evil-window-increase-width
    (kbd "C-<down>") 'evil-window-decrease-height
    (kbd "C-<up>") 'evil-window-increase-height
    (kbd "M-h") 'evil-ex-nohighlight
    ))


;; Allows you to edit entries directly from org-brain-visualize
(add-hook! polymode
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))

;; picpocket
(add-hook 'picpocket-mode-hook
          (lambda ()
            (local-set-key (kbd "<return>") 'picpocket-next)))
;; rg
(require 'rg)

;; rime
(require 'rime)
(setq rime-user-data-dir "~/.config/fcitx/rime")
(setq default-input-method "rime"
      rime-show-candidate 'posframe)

(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; language tool
(setq langtool-java-classpath
      "/usr/share/languagetool:/usr/share/java/languagetool/*")
(require 'langtool)


(font-lock-add-keywords 'org-mode
                        '(("^ *\([-]\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(font-lock-add-keywords 'org-mode
                        '(("^ *\([+]\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "◦"))))))

(setq-default prettify-symbols-alist '(("#+BEGIN_SRC" . "†")
                                       ("#+END_SRC" . "†")
                                       ("#+begin_src" . "†")
                                       ("#+end_src" . "†")
                                       (">=" . "≥")
                                       ("=>" . "⇨")))
(setq prettify-symbols-unprettify-at-point 'right-edge)
(add-hook 'org-mode-hook 'prettify-symbols-mode)

;; disable company when eshell-mode
(defun my-disable-company-in-eshell ()
  (company-mode -1))

(add-hook 'eshell-mode-hook 'my-disable-company-in-eshell)


;; org-configuration
(after! org
  (add-hook 'org-mode-hook
            (lambda ()
              (variable-pitch-mode 1)
              visual-line-mode))
  (setq
   org-agenda-skip-scheduled-if-done t
   org-hide-emphasis-markers t
   org-startup-indented t
   org-src-tab-acts-natively t
   org-pretty-entities t
   org-log-done 'time
   org-ellipsis " ⭍"
   org-tags-column 0
   org-log-into-drawer t
   org-pretty-entities t
   org-hide-leading-stars nil
   org-image-actual-width '(800)
   org-indent-mode-turns-on-hiding-stars nil
   org-todo-keywords '(
                       (sequence  "TODO(t)" "WAITING(w)" "INPROGRESS(i)" "|" "CANCELLED(c)" "DONE(d)")
                       )
   org-todo-keyword-faces
   '(
     ("TODO" :foreground "#EEEE00" :weight normal :underline t)
     ("WAITING" :foreground "#9f7efe":weight normal :underline t)
     ("INPROGRESS" :foreground "#0098dd":weight normal :underline t)
     ("CANCELLED" :foreground "#ff6480" :weight normal :underline t)
     ("DONE" :foreground "#50a14f" :weight normal :underline t)
     )
   ob-mermaid-cli-path "/usr/bin/mmdc"
   org-directory "~/org/"
   org-noter-notes-search-path '("~/org/notes/")
   org-roam-directory '"~/org/roam/"
   org-roam-db-location '"~/org/roam/org-roam.db"
   org-roam-dailies-directory '"daily/"
   org-roam-db-gc-threshold most-positive-fixnum
   org-startup-with-inline-images t
   org-startup-with-latex-preview t

   org-agenda-files '("~/org/agenda/projects.org"
                      "~/org/agenda/inbox.org"
                      "~/org/agenda/next_actions.org"
                      "~/org/agenda/waiting_for.org"
                      "~/org/agenda/someday.org")

   org-capture-templates
   '(("t" "Todo with Tag Selection" entry
      (file+headline "~/org/agenda/inbox.org" "Inbox")
      "* TODO %?\n  %T"
      :tags " :工作:个人:学习:")
     ("n" "Note with Tag Selection" entry
      (file+headline "~/org/agenda/reference.org" "Notes")
      "** %?\n  %T"
      :tags " :想法:记录:会议:")
     ("p" "Project with Tag Selection" entry
      (file+headline "~/org/agenda/projects.org" "Projects")
      "** %?\n  %T"
      :tags " :重要:长期:")
     ("w" "Waiting For with Tag Selection" entry
      (file+headline "~/org/agenda/waiting_for.org" "Waiting For")
      "* WAITING %?\n  %T"
      :tags " :跟进:等待他人:")
     ("s" "Someday/Maybe with Tag Selection" entry
      (file+headline "~/org/agenda/someday.org" "Someday/Maybe")
      "* %?\n  %T"
      :tags " :将来:也许:")
     )
   ))


(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)
   (scheme . t)
   ))


(use-package org-fancy-priorities
  :ensure t
  :after org
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package org-superstar
  :after org
  :custom
  (org-superstar-leading-bullet ?\s)
  (org-superstar-special-todo-items t)
  (org-superstar-item-bullet-alist '((43 . "⬧") (45 . "⬨")))
  (org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷")))


(use-package visual-fill-column
  :after org
  :custom
  (visual-fill-column-width 88))

(use-package! websocket
  :after org-roam)
(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :if-new (file+head "${slug}.org" "${title}\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)

        ("f" "Fleeting Note" plain "%?"
         :if-new (file+head "fleeting/%<%Y%m%d%H%M%S>-${slug}.org" "%<%Y%m%d%H%M%S>--${title}\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)

        ("l" "Literature Note" plain "%?"
         :if-new (file+head "literature/${slug}.org" "${title}\n#+ROAM_KEY: ${ref}\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)))
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
