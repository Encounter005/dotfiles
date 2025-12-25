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
(load-theme 'catppuccin t t)
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
;; (load-theme ''noctalia t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


;; custom settings
(setq default-frame-alist '((undecorated . t)))

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

;; error lens
(use-package flymake
  :custom ((flymake-start-on-flymake-mode nil)
           (flymake-no-changes-timeout nil)
           (flymake-show-diagnostic t)
           (flymake-start-on-save-buffer t)))

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

;; company configuration
(after! sh-script
  (set-company-backend! 'sh-mode nil))
(with-eval-after-load 'company
  ;; 绑定 Enter 键为确认补全
  (define-key company-active-map (kbd "<return>") 'company-complete-selection)
  (define-key company-active-map (kbd "RET") 'company-complete-selection)
  )



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

   org-agenda-files '("~/org/agenda/projects.org"
                      "~/org/agenda/inbox.org"
                      "~/org/agenda/work.org"
                      "~/org/agenda/next_actions.org"
                      "~/org/agenda/archive.org"
                      "~/org/agenda/waiting.org")

   org-capture-templates
   '(("t" "Todo [Inbox]" entry (file+headline "~/org/agenda/inbox.org" "Tasks")
      "* TODO %^{任务描述}  :%^{任务类型|dev|bugfix|env|doc|meeting}:\n  SCHEDULED: %^t\n  PRIORITY: %^{优先级|A|B|C|D}\n  %?\n  %i" :prepend t)
     ("b" "Blog" plain (file ,(concat "~/org/blogs" (format-time-string "%Y-%m-%d.md")))
      ,(concat "#+title: %^{标题}\n"
               "#+date: %U\n"
               "#+hugo_categories: %^{分类}\n"
               "#+hugo_TAGS: %^{标签}\n"
               "#+hugo_draft: %^{草稿|true|false}\n"
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


   org-babel-load-languages
   '((mermaid . t)
     (scheme . t))
   ))


(defun my/org-auto-refile-on-state-change ()
  "根据 TODO 状态自动将任务移动到对应的文件。"
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

     ((string= state "DONED")
      (setq target-file "~/org/agenda/archive.org")
      (setq target-headline "Archived"))

     ((string= state "NEXT")
      (setq target-file "~/org/agenda/next_actions.org")
      (setq target-headline "Next Actions")))
    ;; 修正: 只有当 target-file 被赋值时才执行，防止报错
    (when target-file
      (if (file-exists-p target-file)
          (progn
            (org-refile nil nil (list target-headline target-file nil nil))
            (message "任务已自动移至: %s" target-file))
        (message "错误：找不到目标文件 %s" target-file)))))

(add-hook 'org-after-todo-state-change-hook #'my/org-auto-refile-on-state-change)


(use-package org-fancy-priorities
  :ensure t
  :after org
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '((?A . "❗")
                                    (?B . "⬆")
                                    (?C . "⬇")
                                    (?D . "☕")
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
  (org-superstar-item-bullet-alist '((43 . "⬧") (45 . "⬨")))
  (org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷")))

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

     ("w" "周计划日程"
      ((agenda "" ((org-agenda-span 'week)
                   (org-agenda-start-on-weekday 1)
                   (org-agenda-overriding-header "本周时间轴")
                   (org-super-agenda-groups
                    '((:name "⏰ 时间轴任务" :time-grid t) ;; 匹配有具体时间的条目
                      (:name "📅 今日计划" :scheduled today)
                      (:name "⚠️ 逾期未完成" :deadline past)
                      (:name "🏁 截止日临近" :deadline future)
                      ;; 建议在周视图暂时不要 discard 掉所有，方便调试
                      )))))))
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
