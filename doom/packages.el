;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)

(package! challenger-deep-theme)
(package! catppuccin-theme)
(package! impatient-mode)
(package! org-super-agenda)
(package! org-transclusion)
;; (package! emacs-application-framework
;;   :recipe (:host github :repo "emacs-eaf/emacs-application-framework"
;;            :files ("*.el" "*.json" "*.py" "core" "extension" "app" "reinput")
;;            :build (:not compile)))
;; (package! pop-web
;;   :recipe (:host github :repo "manateelazycat/popweb"
;;            :files ("*.el" "*.py" "*.js" "extension")
;;            :build (:not compile)))

(package! htmlz-mode
  :recipe (:host github :repo "0xekez/htmlz-mode"
           :files ("*.el")
           :build (:not compile)))
(package! codeium :recipe (:host github :repo "Exafunction/codeium.el"))
(package! rime
  :recipe (:host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c"))
  )
(package! postframe
  :recipe (:host github :repo "tumashu/posframe" :files ("*.el" ))
  )

(unpin! org-roam)
(package! org-roam-ui)
(package! ob-mermaid)
(package! pdf-tools)

(package! livedown
  :recipe (:host github :repo "shime/emacs-livedown" :files ("*.el"))
  )

;; (package! google-translate)
(package! fanyi)

(package! picpocket
  :recipe (:host github :repo "johanclaesson/picpocket" :files ("*.el"))
  )

(package! htmlz-mode
  :recipe (:host github :repo "0xekez/htmlz-mode" :files ("*.el"))
  )
(package! org-pretty-table
  :recipe (:host github :repo "Fuco1/org-pretty-table" :files ("*.el"))
  )
(package! rg)
(package! org-bullets)
(package! impatient-mode)

(package! djvu
  :recipe (:host github :repo "emacsmirror/djvu" :files ("*.el"))
  )

(package! djvu3
  :recipe (:host github :repo "dalanicolai/djvu3" :files ("*.el"))
  )

(package! valign)
(package! org-superstar)
(package! visual-fill-column)
