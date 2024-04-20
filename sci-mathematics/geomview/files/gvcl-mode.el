;;; gvcl-mode.el --- A major mode for editing Geomview Command Language files

;; Copyright (C) 2007  Claus-Justus Heine

;; Author: Claus-Justus Heine
;; Keywords: extensions

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Writing an Emacs major mode is really a non-trivial task. This file
;; really covers only some basic things (comment-start,
;; syntax-highlighting, crude indentation support).

;;; Code:

;; Setup

;;First, we define some variables that all modes should
;;define. gvlisp-mode-hook allows the user to run their own code when
;;your mode is run

(defvar gvcl-mode-hook nil)

(defvar gvcl-indent-offset 2 "Incremental indentation offset.")

;;Now we create a keymap. This map, here called gvcl-mode-map, allows
;;both you and users to define their own keymaps. The keymap is
;;immediately set to a default keymap. Then, using define-key, we
;;insert an example keybinding into the keymap, which maps the
;;newline-and-indent function to Control-j (which is actually the
;;default binding for this function, but is included anyway as an
;;example). Of course, you may define as many keybindings as you wish.
;;
;;If your keymap will have very few entries, then you may want to
;;consider make-sparse-keymap rather than make-keymap
(defvar gvcl-mode-map
  (let ((gvcl-mode-map (make-keymap)))
    (define-key gvcl-mode-map "\C-j" 'newline-and-indent)
    gvcl-mode-map)
  "Keymap for Geomview Command Language major mode.")

;;Here, we append a definition to auto-mode-alist. This tells emacs
;;that when a buffer with a name ending with .wpd is opened, then
;;gvcl-mode should be started in that buffer. Some modes leave this
;;step to the user.
(add-to-list 'auto-mode-alist '("\\.gcl\\'" . gvcl-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax highlighting using keywords

(defconst gvcl-font-lock-keywords-1
  (list
   '("(\\s-*\\(redraw\\|process-events\\|interest\\|time-interests\\|and\\|sleep-\\(for\\|until\\)\\|or\\|hdefine\\|geometry\\|quote\\|eval\\|if\\|while\\|setq\\|echo\\|let\\|exit\\|quit\\|lambda\\|defun\\|progn\\|backcolor\\|read\\|camera\\|new-geometry\\|car\\|cdr\\|cons\\|emodule\\S-*\\|ui-\\S-+\\|normalization\\)\\>" . font-lock-builtin-face)
   '("\\(\"\\w*\"\\)" . font-lock-variable-name-face))
  "Minimal highlighting expressions for GVCL mode.")

(defconst gvcl-font-lock-keywords-2
  (append gvcl-font-lock-keywords-1
		  (list
		   '("\\<\\(\\(location\\|origin\\)\\s-+\\(camera\\|local\\|global\\|ndc\\|screen\\)\\)\\>" . font-lock-constant-face)
		   '("\\<\\(define\\|geom\\(etry\\)?\\|camera\\|window\\|inertia\\|allgeoms\\|focus-change\\)\\>" . font-lock-keyword-face)))
  "Additional Keywords to highlight in GVCL mode.")

(defconst gvcl-font-lock-keywords-3
  (append gvcl-font-lock-keywords-2
		  (list
		   '("\\<\\(INST\\|T?LIST\\|\\(ST\\)?Z?u?v?C?N?U?4?n?\\(OFF\\|MESH\\|SKEL\\|VECT\\|QUAD\\|BEZ\\|BBP\\|BBOX\\|SPHERE\\|GROUP\\|DISCGRP\\|COMMENT\\)\\)\\>" . font-lock-type-face)
		   ;; more OOGL keywords
		   '("\\<\\(SINUSOIDAL\\|CYLINDRICAL\\|RECTANGULAR\\|STEREOGRAPHIC\\|ONEFACE\\)\\>" . font-lock-keyword-face)
		   ;; apperance constants
		   '("\\<\\(blend\\|modulate\\|replace\\|decal\\|replacelights\\|face\\|edge\\|vect\\|transparent\\|normal\\|normscale\\|evert\\|texturing\\|mipmap\\|linear\\|mipinterp\\|backcull\\|concave\\|shadelines\\|keepcolor\\|smooth\\|flat\\|constant\\|csmooth\\|vcflat\\|replacelights\\|clamp\\s-+\\(s\\|t\\|st\\|none\\)\\)\\>" . font-lock-constant-face)
		   ;; image constants
		   '("\\<\\(RGB\\|RGBA\\|ALPHA\\|LUMINANCE\\|LUMINANCE_ALPHA\\)\\>" . font-lock-constant-face)
		   ;; image keywords
		   '("\\<\\(inertia\\|width\\|height\\|channels\\|maxval\\|data\\)\\>" . font-lock-keyword-face)
		   ;; apperance keywords
		   '("\\<\\(apply\\|shading\\|localviewer\\|attenconst\\|attenmult2?\\|normscale\\|shading\\|linewidth\\|patchdice\\|ka\\|ambient\\|kd\\|diffuse\\|ks\\|specular\\|shininess\\|backdiffuse\\|alpha\\|edgecolor\\|normalcolor\\|color\\|position\\|file\\|alphafile\\|background\\|texturing\\)\\>" . font-lock-keyword-face)
		   ;; some more types
		   '("\\<\\(texture\\|light\\|material\\|lighting\\|light\\|image\\|appearance\\|n?transforms?\\|tlist\\)\\>" . font-lock-type-face)
		   ;; some more constants
		   '("\\<\\(yes\\|no\\|on\\|off\\|toggle\\|center\\|none\\)\\>" . font-lock-constant-face)
		   ))
  "Balls-out highlighting in GVCL mode.")

;;I've now defined more GVCL constants. This completes the list of
;;GVCL keywords.

(defvar gvcl-font-lock-keywords gvcl-font-lock-keywords-3
  "Default highlighting expressions for GVCL mode.")

;;Here I've defined the default level of highlighting to be the
;;maximum. This is just my preference\u2014 the user can change this
;;variable (if the user knows how! This might be something to put in
;;the documentation for your own mode).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Indentation

(defun gvcl-indent-line ()
  "Indent current line as GVCL code."
  (interactive)
;;  (beginning-of-line)
  (let ((savep (> (current-column) (current-indentation)))
	(indent (condition-case nil (max (gvcl-calculate-indentation) 0)
		  (error 0))))
    (if savep
	(save-excursion (indent-line-to indent))
      (indent-line-to indent))))

(defun gvcl-calculate-indentation ()
   "Return the column to which the current line should be indented."
   (save-excursion
     (beginning-of-line)
     (if (< (point) 2)
	 0
       (skip-chars-forward " \t")
       (let ((indent-above (if (eq (char-syntax (following-char)) ?\) )
			       0
			     gvcl-indent-offset)))
	 (up-list -1)
	 (+ (current-indentation) indent-above)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The syntax table

(defvar gvcl-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?{ "(}" st)
    (modify-syntax-entry ?} "){" st)
    (modify-syntax-entry ?( "()" st)
    (modify-syntax-entry ?) ")(" st)
    st)
  "Syntax table for `gvcl-mode'.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Derive the stuff from fundamental mode

(define-derived-mode gvcl-mode fundamental-mode "GVCL"
  "Major mode for editing Geomview Command Language files."
  (set (make-local-variable 'font-lock-defaults) '(gvcl-font-lock-keywords))
  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-start-skip) "#+\\s-*")
  (set (make-local-variable 'indent-line-function) 'gvcl-indent-line))


(provide 'gvcl-mode)

(provide 'gvcl-mode)

;;; gvcl-mode.el ends here
