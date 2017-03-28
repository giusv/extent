(defprod element (panel ((name symbol)
                         (header element)
			 (body element)
			 &optional (footer element)))
  (to-list () `(panel (:name ,name :header ,(synth to-list header) :body ,(synth to-list body) :footer ,(synth to-list footer))))
  ;; (to-req (path) (text "Pannello composto da????????"))
  (to-html (path) (multitags 
                   (text "Pannello identificato come")
                   (span-color (lower-camel name)) 
                   (text "e composto da:")
                   (dlist header (span nil (text "header")) (synth to-html header path)
                          body (span nil (text "body")) (synth to-html body path)
                          footer (span nil (text "footer")) (synth to-html footer path))))
  (to-brief (path) (synth to-html (panel header body footer) path))
  (toplevel () nil)
  (req (path) nil))

(defmacro panel* (header body &optional footer)
  `(panel (gensym "PANEL") ,header ,body ,footer))
