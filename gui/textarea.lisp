(defprod element (textarea ((name string)
                            (label expression)
                            &key (init (init expression))))
  (to-list () `(textarea (:name ,name :label ,(synth to-list label) :init ,(synth to-list init))))
  (to-html (path) (multitags (text "Area di testo identificata come")
                             (span-color (lower-camel name))
                             (text " etichettata con ")
                             (synth to-html label) 
                             (dlist init (span nil (text "Valore iniziale")) (synth to-html init))))
  (to-brief (path) (synth to-html (textarea name label :init init) path))
  (to-model () (jstring (value (textarea name label :init init))))
  (toplevel () nil)
  (req (path) nil))

(defmacro textarea* (label &key init)
  `(textarea (gensym "TEXTAREA") ,label :init ,init))
