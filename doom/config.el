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
(setq doom-font (font-spec :family "ComicShannsMono Nerd Font Mono" :size 20 )
      doom-variable-pitch-font (font-spec :family "ComicShannsMono Nerd Font" :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (load-theme 'noctalia t)
;; (load-theme 'dank-emacs t)
(load-theme 'batppuccin-mocha t)
(setq doom-theme 'batppuccin-mocha)
;; (setq doom-theme 'doom-wilmersdorf)
;; (setq doom-theme 'omtose-darker)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


;; custom settings
;; set tab-width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-ts-mode-indent-offset 4)
(setq-default c-basic-offset 4)
(setq web-mode-markup-indent-offset 4) ; HTML 缩进
(setq web-mode-css-indent-offset 4)    ; CSS 缩进
(setq web-mode-code-indent-offset 4)   ; JS/PHP 缩进
(setq python-indent-offset 4) ;; python 缩进

(setq default-frame-alist '((undecorated . t)))

(setq
 projectile-project-search-path '("~/code/"))

;;LSP
;; make the inlayhints enabled when lsp-mode enabled
(setq lsp-inlay-hint-enable t) ;; 全局开启

;; error lens
;; (setq lsp-lens-enable t)
;; (setq lsp-ui-sideline-show-diagnostics t)


;; cpp
(with-eval-after-load 'cc-mode
  (set-eglot-client! 'cc-mode '("clangd" "-j=3" "--clang-tidy")))



;; python
;; (setq lsp-pyright-python-executable-cmd ".venv/bin/python")
(use-package uv-mode
  :hook (python-mode . uv-mode-auto-activate-hook))
;; pyright
(after! lsp-pyright
  (setq lsp-pyright-type-checking-mode "basic"
        lsp-pyright-auto-import-completions t
        lsp-pyright-multi-root nil
        lsp-pyright-venv-path "."))
(with-eval-after-load 'python
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode))
  (set-eglot-client! '(python-mode python-ts-mode) '("ty" "server"))
  )

;; google translate
(require 'google-translate)
(require 'google-translate-smooth-ui)
(global-set-key "\C-ct" 'google-translate-smooth-translate)


(after! flyspell
  (setq flyspell-lazy-idle-seconds 2))
;;Flyspell will run a series of predicate functions to determine if a word should be spell checked.
(set-flyspell-predicate! '(markdown-mode gfm-mode)
  #'+markdown-flyspell-word-p)
(setq flyspell-default-dictionary "en_US")
(setq ispell-personal-dictionary "english")
;; enable word-wrap (almost) everywhere
(+global-word-wrap-mode +1)

;; error lens
(use-package flymake
  :custom ((flymake-start-on-flymake-mode nil)
           (flymake-no-changes-timeout nil)
           (flymake-show-diagnostic t)
           (flymake-show-diagnostic-at-end-of-line t)
           (flymake-start-on-save-buffer t)))

;; symbols outline
(use-package symbols-outline
  :bind("C-c i" . symbols-outline-show)
  :init
  (add-hook 'eglot-managed-mode-hook
            (lambda()
              (setq-local symbols-outline-fetch-fn #'symbols-outline-lsp-fetch)
              )
            )
  :config
  (setq symbols-outline-window-position 'right)
  (symbols-outline-follow-mode)
  )


;; djvu
(require 'djvu)
(require 'djvu3)

;;auto-save
;; (setq auto-save-visited-interval 5)
;; (auto-save-visited-mode t)
(require 'auto-save)
(auto-save-enable)
(setq auto-save-silent t)
(setq auto-save-delete-trailing-whitespace nil)
(setq auto-save-idle 5)
;;; custom predicates if you don't want auto save.
;;; disable auto save mode when current filetype is an gpg file.
(setq auto-save-disable-predicates
      '((lambda ()
          (string-suffix-p
           "gpg"
           (file-name-extension (buffer-name)) t))))

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

;; corfu
(setq
 corfu-auto t
 corfu-auto-prefix 2
 corfu-auto-delay 0.2
 )

;; dirvish
(map! :leader
      :desc "Dirvish DWIM" "o e" #'dirvish-dwim)


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

;; latex-math preview
;; (add-hook 'org-mode-hook 'org-fragtog-mode)
;; picpocket
(add-hook 'picpocket-mode-hook
          (lambda ()
            (local-set-key (kbd "<return>") 'picpocket-next)))
;; rg
(require 'rg)

;; rime
(require 'rime)
(setq rime-user-data-dir "~/.config/fcitx/rime"
      default-input-method "rime"
      rime-show-candidate 'posframe
      )


;; 设置国内源
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; language tool
(setq langtool-java-classpath
      "/usr/share/languagetool:/usr/share/java/languagetool/*")
(require 'langtool)


;; org-configuration
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

(after! org
  (add-hook 'org-mode-hook
            (lambda ()
              (variable-pitch-mode 1)
              visual-line-mode))

  (with-eval-after-load 'org (global-org-modern-mode))
  (add-hook 'org-mode-hook #'valign-mode)

  (require 'ol-fanyi)
  (setq
   org-agenda-skip-scheduled-if-done t
   org-hide-emphasis-markers t
   org-startup-indented t
   org-src-tab-acts-natively t
   org-pretty-entities t
   org-pretty-entities-include-sub-superscripts nil
   org-log-done 'time
   org-ellipsis " ⭍"
   org-tags-column 0
   org-log-into-drawer t
   org-hide-leading-stars nil
   org-image-actual-width '(800)
   org-indent-mode-turns-on-hiding-stars nil
   org-insert-heading-respect-content t
   org-hide-emphasis-markers t
   org-agenda-tags-column 0
   org-special-ctrl-a/e t
   org-auto-align-tags nil
   org-startup-with-inline-images t
   org-startup-with-latex-preview t
   org-startup-with-animated-gifs t
   org-display-remote-inline-images 'download

   org-download-method 'attach
   org-download-image-dir "~/Pictures/org"

   org-modern-star 'nil
   org-modern-table 'nil

   org-todo-keywords
   '((sequence "TODO(t)" "INPROGRESS(i)" "WAITING(w@/!)" "NEXT(n@/!)" "|" "DONE(d!)" "CANCELLED(c@)"))
   ;; ！表示切换到该状态时记录时间，@表示记录一条备注

   ob-mermaid-cli-path "/usr/bin/mmdc"
   org-directory "~/org/"
   org-noter-notes-search-path '("~/org/notes/")
   org-roam-directory '"~/org/roam/"
   org-roam-db-location '"~/org/roam/org-roam.db"
   org-roam-dailies-directory '"daily/"
   org-roam-db-gc-threshold most-positive-fixnum
   org-startup-with-inline-images t
   org-startup-with-latex-preview t
   org-hugo-base-dir '"~/blogs"
   org-agenda-files '("~/org/agenda/projects.org"
                      "~/org/agenda/inbox.org"
                      "~/org/agenda/work.org"
                      "~/org/agenda/next_actions.org"
                      "~/org/agenda/archive.org"
                      "~/org/agenda/waiting.org")

   org-capture-templates
   `(("t" "Todo [Inbox]" entry (file+headline "~/org/agenda/inbox.org" "Tasks")
      "* TODO [#%^{优先级|A|B|C|D}] %^{任务描述}  :%^{任务类型|dev|bugfix|env|doc|meeting}:\n  SCHEDULED: %^t\n %?\n  %i" :prepend t)
     ("b" "Blog" plain (file my/org-capture-blog-path)
      ,(concat "#+TITLE: %(file-name-base (org-capture-get :custom-title))\n"
               "#+DATE: %U\n"
               "#+HUGO_CATEGORIES: %^{分类}\n"
               "#+HUGO_TAGS: %^{标签(每一个标签一个空格)}\n"
               "#+HUGO_DRAFT: %^{草稿|true|false}\n"
               "\n"
	       "%?"))
     ("n" "Next Action" entry (file+headline "~/org/agenda/next_actions.org" "Next Action")
      "* NEXT %?\n  SCHEDULED: %t" :prepend t)
     ("p" "Project" entry (file+headline "~/org/agenda/projects.org" "New Projects")
      "* %^{Project Name}\n%?" :prepend t)
     ("s" "Someday" entry (file+headline "~/org/agenda/someday.org" "Maybe")
      "* %?\n  %U" :prepend t))


   org-refile-targets '(("~/org/agenda/next_actions.org" :maxlevel . 1)
                        ("~/org/agenda/projects.org" :maxlevel . 1)
                        ("~/org/agenda/waiting.org" :maxlevel . 1)
                        ("~/org/agenda/work.org" :maxlevel . 1)
                        ("~/org/agenda/archive.org" :maxlevel . 1)
                        ("~/org/agenda/someday.org" :maxlevel . 1))

   org-outline-path-complete-in-steps nil
   org-refile-use-outline-path 'file

   org-todo-keyword-faces
   '(("TODO" . (:foreground "OrangeRed" :weight bold))
     ("INPROGRESS" . (:foreground "DeepSkyBlue" :weight bold))
     ("DONE" . (:foreground "ForestGreen" :weight bold))
     ("NEXT" . (:foreground "Yellow" :weight bold))
     ("WAITING" . (:foreground "Violet" :weight bold)))

   org-agenda-current-time-string "◀── 现在 ─────────────────────────────────────────"

   org-tag-alist '((:startgroup)
                   ("@Office" . ?o)
                   ("@Home" . ?h)
                   (:endgroup)
                   ("Urgent" . ?u)
                   ("Learning" . ?l)
                   ("Working" . ?w)
                   ("Research" . ?r))




   ))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (mermaid . t)
   (scheme . t))
 )
(add-hook 'org-mode-hook #'auto-revert-mode)

(defun my/org-capture-blog-path ()
  "输入博客的标题"
  (let* ((title (read-string "博客标题: "))
         ;; 处理文件名：空格转横杠，转小写
         (filename (replace-regexp-in-string " " "-" (downcase title)))
         (path (expand-file-name (format "%s.org" filename) "~/org/blogs/")))
    ;; 把原始的、漂亮的 title 存起来，给模板用
    (org-capture-put :custom-title title)
    path))


(defun my/org-auto-refile-on-state-change ()
  "根据 TODO 状态自动移动任务，但跳过 projects.org。"
  (let ((current-file (buffer-file-name)))
    ;; 特判：如果当前文件路径包含 "projects.org"，则直接退出函数
    (unless (and current-file (string-match-p "projects\\.org" current-file))
      (let* ((state org-state)
             (target-file nil)
             (target-headline nil))

        (cond
         ((string= state "INPROGRESS")
          (setq target-file "~/org/agenda/work.org")
          (setq target-headline "Current Tasks"))

         ((string= state "WAITING")
          (setq target-file "~/org/agenda/waiting.org")
          (setq target-headline "Waiting Tasks"))

         ((string= state "DONE")
          (setq target-file "~/org/agenda/archive.org")
          (setq target-headline "Archived"))

         ((string= state "NEXT")
          (setq target-file "~/org/agenda/next_actions.org")
          (setq target-headline "Next Actions")))

        ;; 只有当 target-file 被赋值时才执行
        (when target-file
          (if (file-exists-p target-file)
              (progn
                ;; 注意：org-refile 在 hook 中使用时有时需要配合 save-excursion
                (org-refile nil nil (list target-headline target-file nil nil))
                (message "任务已自动移至: %s" target-file))
            (message "错误：找不到目标文件 %s" target-file)))))))

(add-hook 'org-after-todo-state-change-hook #'my/org-auto-refile-on-state-change)



(use-package org-modern-indent
                                        ; or
                                        ; :straight (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent"))
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-fancy-priorities
  :after org
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '((?A . "󰈸")
                                    (?B . "󰹲")
                                    (?C . "󰶟")
                                    (?D . "󰈄")
                                    (?1 . "⚡")
                                    (?2 . "⮬")
                                    (?3 . "⮮")
                                    (?4 . "☕")
                                    (?I . "Important"))))
(use-package org-superstar
  :after org
  :custom
  (org-superstar-leading-bullet ?\s)
  (org-superstar-special-todo-items t)
  (org-superstar-item-bullet-alist '((?+ . ?➥) (?- . ?❖)))
  ;; (org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷"))
  )
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

(use-package org-super-agenda
  :init
  ;; 在加载前可以设置的一些基础变量
  (setq org-super-agenda-groups nil) ; 先清空默认值
  :config
  (org-super-agenda-mode 1)
  (setq
   org-agenda-custom-commands
   '(("g" "GTD 全局视图"
      ((todo "" ((org-agenda-overriding-header "所有待办状态汇总")
                 (org-super-agenda-groups
                  '((:name "🚀 正在进行" :todo "INPROGRESS" :order 1)
                    (:name "📥 收件箱" :file-path "inbox.org" :order 2)
                    (:name "🚧 项目" :file-path "projects.org" :order 3)
                    (:name "⏳ 等待中" :todo "WAITING" :time-grid t :order 4)
                    (:name "📅 有时间期限" :deadline t :order 5)
                    (:name "🔧 下一步计划":file-path "next_actions.org" :time-grid t :order 6)
                    (:name "🕰 未来规划":file-path "someday.org" :order 7)
                    ))))))

     )
   )
  )
;; 确保在进入 Agenda 之前，这个模式是开着的
(add-hook 'org-agenda-mode-hook 'org-super-agenda-mode)

(use-package visual-fill-column
  :after org
  :custom
  (visual-fill-column-width 88))

(use-package! websocket
  :after org-roam)


(require 'org-download)
(add-hook 'dired-mode-hook 'org-download-enable)

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

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target(file+head "${slug}.org" "#+title: ${title}\n#+startup: overview\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)

        ("c" "Code" plain "%?"
         :target
         (file+head "code/${slug}.org"
                    "#+title: ${title}\n#+startup: overview\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)

        ("k" "Knowledge" plain "%?"
         :target
         (file+head "knowledge/${slug}.org"
                    "#+title: ${title}\n#+startup: overview\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)

        ("t" "Tools" plain "%?"
         :target
         (file+head "tools/${slug}.org"
                    "#+title: ${title}\n#+startup: overview\n#+filetags: :%^{Tags}:\n")
         :unnarrowed t)

        ("r" "Research" plain "%?"
         :target (file+head "research/${slug}.org" "#+title: ${title}\n#+startup: overview\n#+ROAM_KEY: ${ref}\n#+filetags: :Research %^{Tags}:\n")
         :unnarrowed t)))
;; webkit
(require 'webkit)
(require 'webkit-ace)
(require 'webkit-dark)

;; latex
(setq +latex-viewers '(zathura))
;; 语法高亮
(setq org-highlight-latex-and-related '(native latex entities))

;; focus
(beacon-mode 1)

;; fanyi-dwim
(setq read-extended-command-predicate #'command-completion-default-include-p)

;; golden-ratio
(require' golden-ratio)
(golden-ratio-mode 1)

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
