(defpackage :gui
  (:use :common-lisp))

(defmacro element (name &body elem)
  `(defparameter ,name ,@elem))

(defun option-panel (label target)
  (panel* (label (const label))
          (anchor* (const "Vai alla pagina") :click (target target))))

(defmacro hub-spoke (triples base layout)
  `(let* ,(mapcar #'(lambda (triple)
		      (let ((name (first triple))
			    (label (second triple)))
			`(,name (option-panel ,label ,(merge-urls base name)
                                              ;; (if base 
                                              ;;     (url `(,base / ,name))
                                              ;;     (url `(,name)))
                                              ))))
		  triples)
     (alt ,layout ,@(mapcar #'(lambda (triple) 
			(let ((name (first triple))
			      (elem (third triple)))
			  `(static2 ,(keyw name) nil ,elem)))
		    triples))))
