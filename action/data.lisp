(defprod action (extract ((filter filter)
                          (source format)
                          (result variable)))
  (to-list () `(translate (:filter  ,(synth to-list filter) :source ,(synth to-list source) :result ,(synth to-list result))))
  (to-html () (div nil 
		   (text "Sia ") 
		   (synth to-html result) 
		   (text " il risultato della estrazione da ")
                   (synth to-html source)
                   (text" con il seguente filtro:")
		   (div nil (synth to-req filter)))))

(defun extract2 (filter source)
  (let ((result (variab (gensym))))
    (values (extract filter source result) result)))


;; (defprod action (extract ((source format)
;;                           &rest (bindings (plist variable filter))))
;;   (to-list () `(translate (:source ,(synth to-list source) :bindings ,(synth-plist-both to-list to-list bindings))))
;;   (to-html () (div nil 
;; 		   (text "Estrazione da ") 
;; 		   (synth to-html source)
;;                    (text "dei seguenti valori:")
;;                    (apply #'maybes (synth-plist-both to-html to-req bindings)))))

;; (defmacro extract2 (source &rest filters)
;;   (let ((bindings (mapcar #'(lambda (filter)
;;                               (list (gensym) filter)) 
;;                           filters)))
;;     `(extract ,source ,@bindings)))