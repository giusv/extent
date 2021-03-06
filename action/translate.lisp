(defaction (translate ((source filter)
                       (target variable)
                       (result variable)))
    (to-list () `(translate (:source  ,(synth to-list source) :target ,(synth to-list target) :result ,(synth to-list result) :pre ,(synth to-list pre) :post ,(synth to-list post))))
  (to-html () (multitags 
               (text "Sia ") 
               (synth to-html result) 
               (text " il risultato della compilazione di")
               (synth to-html source)
               (dlist pre (text "Precondizione: ") (synth to-html pre)
                      post (text "Postcondizione:") (synth to-html post)))))

(defun translate2 (source &key pre post)
  (let ((result (variab (gensym))))
    (values (translate source nil result :pre pre :post post) result)))

(defaction (assemble ((sources variable)
                      (result variable)))
  (to-list () `(assemble (:source  ,(synth to-list source) :result ,(synth to-list result) :pre ,(synth to-list pre) :post ,(synth to-list post))))
  (to-html () (multitags 
               (text "Sia ") 
               (synth to-html result) 
               (text " il risultato dell'assemblaggio dei codici oggetti presenti in ")
               (synth to-html sources)
               (dlist pre (text "Precondizione: ") (synth to-html pre)
                      post (text "Postcondizione:") (synth to-html post)))))

(defun assemble2 (sources &key pre post)
  (let ((result (variab (gensym))))
    (values (assemble sources result :pre pre :post post) result)))

(defaction (execute ((executable filter)
                     (result variable)))
  (to-list () `(execute (:executable  ,(synth to-list executable) :result ,(synth to-list result) :pre ,(synth to-list pre) :post ,(synth to-list post))))
  (to-html () (multitags 
               (text "Sia ") 
               (synth to-html result) 
               (text " il risultato dell'esecuzione dell'eseguibile ")
               (synth to-html executable)
               (dlist pre (text "Precondizione: ") (synth to-html pre)
                      post (text "Postcondizione:") (synth to-html post)))))

(defun execute2 (executable &key pre post)
  (let ((result (variab (gensym))))
    (values (execute executable result :pre pre :post post) result)))
