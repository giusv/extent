(defprod element (anchor ((name symbol) (expr expression)
			  &key (click (click process)) (hover (hover process))))
  (to-list () `(anchor (:name ,name :expr ,(synth to-list expr) 
			    :click ,(synth to-list click)
			    :hover ,(synth to-list hover))))
  ;; (to-req (path) (vcat (hcat (text "Link identificato come ~a e etichettato con la seguente espressione:" (lower-camel name)) 
  ;;       		     (synth to-req expr))
  ;;       	       (nest 4 (hcat (text "Sottoposto a click, ") (synth to-req click)))
  ;;       	       (synth to-req hover)))
  (to-html (path) (multitags 
		       (text "Link identificato come ")
                       (span-color (lower-camel name))
                       (text " e etichettato con la seguente espressione:") 
                       (synth to-html expr)
                       (dlist click (span nil (text "Sottoposto a click: ")) (synth to-html click)
                              hover (span nil (text "Sottoposto a hover: ")) (synth to-html hover))))
  (to-brief (path) (synth to-html (anchor name expr :click click :hover hover) path)) 
  (toplevel () nil)
  (req (path) nil))

(defmacro anchor* (expr &key click hover)
  `(anchor (gensym "ANCHOR") ,expr :click ,click :hover ,hover))
