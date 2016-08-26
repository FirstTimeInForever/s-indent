(defun s-indent-get-last-block-indent()
  (save-excursion
	(let ((indentation (re-search-backward "{" 0 t))
		  (pos (if (indentation)
				   (point)
				 nil)))
	  (if pos
		  (current-indentation)
		0)
	 )))

(defun s-indent-get-last-expression-indent()
  (interactive)
  (let ((target))
	(save-excursion
	  (if (re-search-backward "[\t(){}[:alnum:]]" 1 t)
		  (progn
			(beginning-of-line)
			(if (looking-at "^[ \t]*{(\\[")
				(setf target (+ (current-indentation) default-tab-width))
			  (progn
				(setf target (current-indentation)))))
		(progn
		  (setq target 0)))
	  )
	target))

(defun s-indent-indent-line()
  "Indent current line"
  (interactive)
  (let ((saved-pos (point))
		(saved-indentation (current-indentation)))
	(beginning-of-line)
	(if (bobp)
		(indent-line-to 0)
	  (progn
		(if (looking-at "^[ \t]*{")
			(progn
			  (indent-line-to (s-indent-get-last-expression-indent)))
		  (progn
			(indent-line-to (s-indent-get-last-expression-indent)))
		  )))
  ))

(defun s-indent-tab()
  (interactive)
  (tab-to-tab-stop))

(defun s-indent-ret()
  (interactive)
  (newline)
  (s-indent-indent-line))

(setq s-indent-mode-keymap
	  (let ((map (make-sparse-keymap)))
		(define-key map (kbd "<tab>") 's-indent-tab)
		(define-key map (kbd "<return>") 's-indent-ret)
		map))

(defvar s-indent-mode-hook nil)

(defun s-indent-mode()
  "Major mode for default indent"
  (interactive)
  (print "Your indentation sucks... I mean really sucks")
  (kill-all-local-variables)
  (use-local-map s-indent-mode-keymap)
  ;;(set (make-local-variable 'indent-line-function) 'nil-call-fix)
  (setq major-mode 's-indent-mode)
  (setq mode-name "Your indentation sucks")
  (local-set-key (kbd "<tab>") 's-indent-tab)
  (local-set-key (kbd "<return>") 's-indent-ret)
  (run-hooks 's-indent-mode-hook))


(define-minor-mode s-indent-minor-mode
  "Simple indent mode"
  :lighter "S-indent"
  :keymap s-indent-mode-keymap
  (run-hooks 's-indent-mode-hook))

(provide 's-indent-mode)
(provide 's-indent-minor-mode)
