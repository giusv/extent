(defprod named-element (dynamic ((name string) 
				 (element element)))
  (to-list () `(dynamic(:name ,name :element ,(synth to-list element))))
  (to-brief (path) (let ((newpath (chain (dynamic-chunk name) path)))
		     (div nil (text "Elemento dinamico di nome ~a " (lower name)) 
			  (parens (hcat (text "percorso: ") (synth to-url newpath))))))
  (to-req (path) (let ((newpath (chain (dynamic-chunk name) path)))
		   (vcat (text "Elemento dinamico di nome ~a" 
			       name) 
			 (hcat (text "percorso: ") (synth to-url newpath))
			 (synth to-req element newpath))))
  (to-html (path) (let ((newpath (chain (dynamic-chunk name) path)))
		    (div nil 
			 (h3 nil (text "Vista dinamica ~a " (lower name)) 
			     (parens (hcat (text "percorso: ") (synth to-url newpath))))
			 (synth to-html element newpath)))))

(defmacro dynamic2 (name element)
  `(dynamic ',name 
	    (let ((,name (path-parameter ',name)))
	      (abst (list ,name) ,element))))