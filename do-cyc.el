(add-to-list 'auto-mode-alist '("\\.docyc$" . do-cyc-todo-list))

(defun do-cyc-todo-list-font-lock-keywords ()
 ""
 do-cyc-todo-list-font-lock-keywords-var)

(defun do-cyc-todo-list ()
 ""
 (interactive)
 (progn 
  (subl-mode)
  (let* ((keywords (formalog-prolog-font-lock-keywords)))
   (setq do-cyc-todo-list-font-lock-keywords-var keywords)
   (do-cyc-todo-list-mode))))

(define-derived-mode do-cyc-todo-list-mode
 subl-mode "DoCyc"
 "Major mode for interacting with .docyc files.
\\{formalog-prolog-mode-map}"
 
 (define-key do-cyc-todo-list-mode-map "\C-cdb" 'do-cyc-todo-list-examcyce-function)

 (setq-local case-fold-search t)
 (make-local-variable 'font-lock-defaults)
 
 (setq font-lock-defaults '(do-cyc-todo-list-font-lock-keywords nil nil))
 (re-font-lock)

 ;; (setq-local company-idle-delay 5)
 ;; (company-mode)
 ;; (add-to-list 'company-backends 'company-do-cyc)
 )

(defun company-do-cyc (command &optional arg &rest ignored)
 (interactive (list 'interactive))
 (case command
  (interactive (company-begin-backend 'company-do-cyc))
  (prefix (cmh-decyclify (cyc-mode-get-cyc-constant-or-symbol-at-point)))
  (candidates (si-list-to-alist
       	       (cl-union
       		(csm-complete-subl (cmh-decyclify (cyc-mode-get-cyc-constant-or-symbol-at-point)))
		(see (csm-complete-cycl (cmh-decyclify (cyc-mode-get-cyc-constant-or-symbol-at-point)))))))
  (meta (format "This value is named %s" arg))))

(defun company-do-cyc-frontend (command)
 ""
 (see command)
 (case command
  (pre-command (echo "%s" (car company-candidates)))
  (post-command (echo "%s" (car company-candidates)))
  (hide (echo ""))))
