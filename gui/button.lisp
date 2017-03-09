(defprod element (button ((name symbol) (expr expression)
			  &key (click (click process)) (hover (hover process))))
  (to-list () `(button (:name ,name :expr ,(synth to-list expr) 
			    :click ,(synth to-list click)
			    :hover ,(synth to-list hover))))
  ;; (to-req (path) (vcat (hcat (text "Pulsante identificato come ~a e etichettato con la seguente espressione:" (lower name)) 
  ;;       		     (synth to-req expr))
  ;;       	       (nest 4 (hcat (text "Sottoposto a click, effettua la seguente azione:") (synth to-req click)))
  ;;       	       (synth to-req hover)))
  (to-html (path) (div (list :class 'well) 
		       (div nil (text "Pulsante identificato come ~a e etichettato con la seguente espressione:" (lower name)) 
			    (synth to-html expr))
                       ;; (maybes2 (list (list click (span nil (text "Sottoposto a click: ")))
                       ;;                (list hover (span nil (text "Sottoposto a hover: "))) path))
                       (dlist click (span nil (text "Sottoposto a click: ")) (synth to-html click)
                              hover (span nil (text "Sottoposto a hover: ")) (synth to-html hover))))
  (to-brief (path) (synth to-html (button name expr :click click :hover hover) path)) 
  (req (path) nil))

(defmacro button* (expr &key click hover)
  `(button (gensym "BUTTON") ,expr :click ,click :hover ,hover))
