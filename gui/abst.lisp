(defprod element (abst ((parameters (list parameter))
		       (element element)))
  (to-list () `(abst (:parameters ,(synth-all to-list parameters) :element ,(synth to-list element))))
  (to-req (path) (vcat (text "Elemento parametrico con parametri:")
		   (nest 4 (apply #'vcat (synth-all to-req parameters)))
		   (synth to-req element path)))
  (to-html (path) (div nil (text "Elemento parametrico ")
		       (apply #'maybes (mapcar #'(lambda (par)
						   (list par (span nil (textify (synth name par)))))
					       parameters))
		       
		       (synth to-html element path)))
  (to-brief (path) (synth to-html (abst parameters element) path))
  (toplevel () (list (synth toplevel element)))
  (req (path) (synth req element path)))
