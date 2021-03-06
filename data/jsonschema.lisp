;;https://hackage.haskell.org/package/json-schema-0.7.4.1/docs/Data-JSON-Schema-Types.html
;;http://cswr.github.io/JsonSchema/spec/grammar/
;; (defprod jsdoc (jsdoc ((id jid) (defs jdefs) (sch jsch)))
;;   (to-json () (apply #'jobject 
;; 		     :id id
;; 		     :definitions (apply #'jobject defs)
;; 		     (synth-plist to-json defs))))

(defmacro json-schema (name elem)
  `(defparameter ,name ,elem))

(defprod data (jsbool ((name symbol) (desc string)))
  (to-list () `(jsbool :name ,(lower-camel name) :desc ,desc))
  ;; (to-req () (text "~a: bool" (lower-camel name)))
  (to-html () (text "booleano. ~a" desc))
  (to-brief () (text "booleano. ~a" desc))
  ;; (instance (val) (jsbool val))
  (schema () (jsbool name desc)))

(defprod data (jsstring ((name symbol) (desc string)))
  (to-list () `(jsstring :name ,(lower-camel name) :desc ,desc))
  ;; (to-req () (text "~a: stringa" (lower-camel name)))
  (to-html () (text "stringa. ~a" desc))
  (to-brief () (text "stringa. ~a" desc))
  ;; (instance (val) (jstring val))
  (schema () (jsstring name desc)))

(defprod data (jsnumber ((name symbol) (desc string)))
  (to-list () `(jsnumber :name ,(lower-camel name) :desc ,desc))
  ;; (to-req () (text "~a: numero" (lower-camel name)))
  (to-html () (text "numero. ~a" desc))
  (to-brief () (text "numero. ~a" desc))
  ;; (instance (val) (jnumber val))
  (schema () (jsnumber name desc)))

;; handle choice in instantiation
;; (defprod data (jschoice (&rest (schemas (list jsschema))))
;;   (to-list () `(jschoice :schemas ,(synth-all to-list schemas)))
;;   (to-req () (vcat (text "scelta tra i seguenti schemi:")
;; 		   (nest 4 (apply #'vcat (synth-all to-req schemas))))))

(defprod data (jsobject ((name symbol) (desc string) &rest (props (list jsprop))))
  (to-list () `(jsobject :name ,(lower-camel name) :desc ,desc :props ,(synth-all to-list props)))
  ;; (to-req () (vcat (text "oggetto denominato ~a dalle seguenti propriet&agrave;:" (lower-camel name) desc)
  ;;       	   (nest 4 (apply #'vcat (synth-all to-req props)))))
  (to-html () (multitags 
               (text "~a:  ~a." (lower-camel name) desc)
               (p nil (text" Esso &egrave; costituito dalle seguenti propriet&agrave;:"))
               (apply #'ul nil 
                      (synth-all to-html props))))
  (to-brief () (text "~a" (upper-camel name)))
  (schema () (apply #'jsobject name desc props)))

(defprod jsprop (jsprop ((name string) (required bool) (content jsschema)))
  (to-list () `(jsprop :name ,name :required ,required :content ,(synth to-list content)))
  ;; (to-req () (hcat (text "~a" name) (if required (text " (obbligatoria)") (text " (facoltativa)")) 
  ;;       	   (text ": ") (synth to-req content)))
  (to-html () (li nil  (hcat (text "~a" (lower-camel name)) (if required (text " (obbligatoria)") (text " (facoltativa)")) 
                             (text ": ")) (synth to-brief content)))
  (schema () (jsprop name required content)))

(defprod data (jsarray ((name symbol) (desc string) (elem jsschema)))
  (to-list () `(jsarray :name ,(lower-camel name) :desc ,desc :elem ,(synth to-list elem)))
  ;; (to-req () (vcat (text "array denominato ~a costituito dal seguente elemento:" (lower-camel name))
  ;;       	   (nest 4 (synth to-req elem))))
  (to-html () (multitags
               (text "array (~a) denominato ~a costituito dal seguente elemento:" desc (lower-camel name))
               (synth to-html elem)))
  (to-brief () (text "~a" (upper-camel name)))
  (schema () (jsarray name desc elem)))

(defun get-this ()
  #'(lambda (jsschema)
      (list jsschema)))
(defun get-elem ()
  #'(lambda (jsschema)
      (list (synth elem jsschema))))

(defun get-prop (name)
  #'(lambda (jsschema)
      (synth-all content 
		 (remove-if-not #'(lambda (prop) 
				    (eql name (synth name prop)))
				(synth props jsschema)))))

(defun compose-filter (f g)
  #'(lambda (jsschema)
      (let ((temps (funcall f jsschema))) ;;temps is a list of jsschema
	(apply #'append (mapcar #'(lambda (temp) 
				    (funcall g temp))
				temps)))))

(defun compose-filters (&rest filters)
  #'(lambda (jsschema)
      (funcall (reduce #'compose-filter filters) jsschema)))



(defprod filter (this ())
  (to-list () `(this))
  (to-func () (get-this))
  (to-req () (text "this"))
  (to-html () (text "this")))

(defprod filter (prop ((name string)))
  (to-list () `(prop (:name ,name)))
  (to-func () (get-prop name))
  (to-req () (text "~a" (lower-camel name)))
  (to-html () (span nil (text "~a" (lower-camel name)))))

(defprod filter (elem ())
  (to-list () `(elem))
  (to-func () (get-elem))
  (to-req () (text "#"))
  (to-html () (span nil (text "#"))))

(defprod filter (comp (&rest (filters (list filter))))
  (to-list () `(comp (:filters ,(synth-all to-list filters))))
  (to-func () (apply #'compose-filters (synth-all to-func filters)))
  (to-req () (apply #'punctuate (forward-slash) nil (synth-all to-req filters)))
  (to-html () (span nil (apply #'punctuate (forward-slash) nil (synth-all to-req filters)))))

(defun parse-filter ()
  (do-with ((filters (sepby (item) (sym '>>>))))
    (result (apply #'comp (mapcar #'eval filters)))))

(defun filter (filt obj) 
  (car (funcall (synth to-func filt) obj)))

;; (pprint (synth to-list (car (funcall (get-prop 'addresses) *user*))))
;; (pprint (synth to-list (car (funcall (get-elem) *addresses*))))

;; (pprint (synth to-list (car (funcall (comp (comp (get-prop 'addresses) (get-elem)) (get-prop 'city)) *user*))))
;; (defparameter *address*
;;   (jsobject (jsprop 'city t (jsstring 'city-string))
;;             (jsprop 'state t (jsstring 'state-string))))
;; (defparameter *addresses* (jsarray 'address-array *address*))
;; (defparameter *user* 
;;   (jsobject 'user-object 
;;             (jsprop 'name t (jsstring 'name-string))
;; 	    (jsprop 'addresses t *addresses*)
;; 	    (jsprop 'numbers t (jsarray 'numbers-array (jsnumber 'number-number)))))



;; (pprint (synth to-list (car (funcall (compose-filters (get-prop 'addresses) (get-elem) (get-prop 'city)) *user*))))
;; (pprint (synth to-list (car (funcall (synth to-func (comp (prop 'addresses) (elem) (prop 'city))) *user*))))
;; (pprint (synth to-list (car (funcall 
;; 			     (synth to-func (parse (parse-filter) 
;; 						   '((prop 'addresses) >>> (elem)))) *user*))))
