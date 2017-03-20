(defaction (create-instance ((entity entity)
                             (result variable)
                             (bindings (plist filter expression))))
    (to-list () `(create-instance :entity ,(synth to-list entity) :result ,(synth to-list result) :bindings ,(synth-all to-list bindings) :pre ,(synth to-list pre) :post ,(synth to-list post)))
  (to-req () (hcat (text "Creazione di un'istanza dell'entit� ")
                   (synth to-req entity)))
  (to-html () (multitags 
               (text "Sia ") 
               (synth to-html result) 
               (text " il risultato della creazione della seguente entit�:")
               (p nil (synth to-html entity))
               (p nil (text "con i seguenti valori:"))
               (apply #'multitags (synth-plist-merge 
                                   #'(lambda (binding) (p nil (synth to-req (first binding)) 
                                                            (text " <- ") 
                                                            (synth to-html (second binding)))) 
                                   bindings))
               (dlist pre (text "Precondizione: ") (synth to-html pre)
                      post (text "Postcondizione:") (synth to-html post)))))


(defun create-instance2 (entity bindings &key pre post)
  (let ((result (variab (gensym))))
    (values (create-instance entity result bindings :pre pre :post post) result)))

(defaction (persist ((entity expression)))
    (to-list () `(persist :entity ,(synth to-list entity) :pre ,(synth to-list pre) :post ,(synth to-list post)))
  (to-req () (hcat (text "Memorizza nel database l'entit� ")
                   (synth to-req entity)))
  (to-html () (multitags (synth to-req (persist entity))
                         (dlist pre (text "Precondizione: ") (synth to-html pre)
                                post (text "Postcondizione:") (synth to-html post)))))


(defaction (fetch ((entity expression)
                   (result variable)
                   &key (id (id expression))))
    (to-list () `(fetch :entity ,(synth to-list entity) :result ,(synth to-list result) :id ,(synth to-list id) :pre ,(synth to-list pre) :post ,(synth to-list post)))
  (to-req () (hcat (text "Estrae dal database i dati relativi all'entit�")
                   (synth to-req entity)
                   (if id (hcat (text "usando come chiave primaria il valore della seguente espressione:")
                                (synth to-req id)))))
  (to-html () (multitags
               (text "Sia ") 
               (synth to-html result) 
               (text " il risultato della estrazione seguente entit�:")
               (p nil (synth to-html entity))
               (if id (multitags (text "usando come chiave primaria il valore della seguente espressione:")
                                 (synth to-html id)))
               (dlist pre (text "Precondizione: ") (synth to-html pre)
                      post (text "Postcondizione:") (synth to-html post)))))


(defun fetch2 (entity &key id pre post)
  (let ((result (variab (gensym))))
    (values (fetch entity result :id id :pre pre :post post) result)))


(defaction (erase ((entity expression)
                   (result variable)
                   (id expression)))
    (to-list () `(erase :entity ,(synth to-list entity) :result ,(synth to-list result) :id ,(synth to-list id) :pre ,(synth to-list pre) :post ,(synth to-list post)))
  (to-req () (hcat (text "Rimuove dal database l'entit�")
                   (synth to-req entity)
                   (hcat (text "usando come chiave primaria il valore della seguente espressione:")
                         (synth to-req id))))
  (to-html () (multitags 
               (text "Sia ") 
               (synth to-html result) 
               (text " il risultato della rimozione dal database della seguente entit�:")
               (p nil (synth to-html entity))
               (p nil (text "usando come chiave primaria il valore della seguente espressione:")
                  (synth to-html id))
               (dlist pre (text "Precondizione: ") (synth to-html pre)
                      post (text "Postcondizione:") (synth to-html post)))))


(defun erase2 (entity id &key pre post)
  (let ((result (variab (gensym))))
    (values (erase entity result id :pre pre :post post) result)))
