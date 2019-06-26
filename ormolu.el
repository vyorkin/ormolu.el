;;; ormolu.el --- Format Haskell source code using the "ormolu" program -*- lexical-binding: t -*-

;; Author: Vasiliy Yorkin <vasiliy.yorkin@gmail.com>
;; Maintainer: Vasiliy Yorkin
;; Version: 0.1.0-snapshot
;; Homepage: homepage
;; Keywords: haskell, formatter, ormolu

;; This file is NOT part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides a minor mode and commands for easily using the "ormolu"
;; program to reformat Haskell code.

;;; Code:

;; Customization properties

(defgroup ormolu nil
  "Integration with the \"ormolu\" formatting program."
  :prefix "ormolu-"
  :group 'haskell)

(defcustom ormolu-process-path "ormolu"
  "Location where the ormolu executable is located."
  :group 'ormolu
  :type 'string
  :safe #'stringp)

(defcustom ormolu-extra-args nil
  "Extra arguments to give to ormolu"
  :group 'ormolu
  :type 'sexp
  :safe #'listp)

(defcustom ormolu-reformat-buffer-on-save nil
  "Set to t to run `ormolu-format-buffer` when a buffer in `:mode` is saved."
  :group 'ormolu
  :type 'boolean
  :safe #'booleanp)

;; Minor mode

(defvar ormolu-mode-map (make-sparse-keymap)
  "Local keymap used for `ormolu-mode`.")

;;;###autoload
(define-minor-mode ormolu-mode
  "Minor mode to format code with the \"ormolu\" program.

Provide the following keybindings:

\\{ormolu-mode-map}"
  :init-value nil
  :keymap ormolu-mode-map
  :lighter " Or"
  :group 'ormolu
  :require 'ormolu
  (if ormolu-mode
      (add-hook 'before-save-hook 'ormolu--before-save nil t)
    (remove-hook 'before-save-hook 'ormolu--before-save t)))

(defun ormolu--before-save ()
  "Optionally reformat the buffer on save."
  (when ormolu-reformat-buffer-on-save
    (ormolu-format-buffer)))

;; Interactive functions

(defun ormolu--format-call (buf)
  "Format BUF using \"ormolu\"."
  (with-current-buffer (get-buffer-create "*ormolu*")
    (erase-buffer)
    (insert-buffer-substring buf)
    (let ((ret (apply #'call-process-region
                      (append (list
                               (point-min)
                               (point-max)
                               ormolu-process-path
                               t
                               t
                               nil)
                              (cons "/dev/stdin" ormolu-extra-args)))))
      (if (zerop ret)
          (progn
            (if (not (string= (buffer-string) (with-current-buffer buf (buffer-string))))
                (copy-to-buffer buf (point-min) (point-max)))
            (kill-buffer))
        (error "ormolu failed, see *ormolu* buffer for details")))))

;;;###autoload
(defun ormolu-format-buffer ()
  "Format the current buffer using \"ormolu\"."
  (interactive)
  (unless (executable-find ormolu-process-path)
    (error "Could not locate executable \"%s\"" ormolu-process-path))
  (ormolu--format-call (current-buffer))
  (message "Formatted buffer with \"ormolu\"."))

(provide 'ormolu)

;;; ormolu.el ends here
