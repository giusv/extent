(defprod element (listing% ((name symbol)
                            (source datasource)
                            (element element)))
  (to-list () `(listing (:name ,name 
                               :source ,(synth to-list source) 
                               :element,(synth to-list (funcall element (synth schema source))))))
  (to-html (path)
	   (div nil
                (text "Lista denominata ")
            (span-color (lower-camel name))
            (text " associata a ")
            (span-color (lower-camel (synth name source)))
            (text "(istanza del formato dati ")
            (a (list :href (concatenate 'string "#" (synth to-string (synth to-brief (synth schema source)) 0)))
               (code nil (synth to-brief (synth schema source )))) 
            (text "con la seguente espressione:") 
            (p nil (synth to-html (funcall element (synth schema source)) path))))
  (to-brief (path) (synth to-html (listing name source element)))
  (toplevel () nil)
  (req (path) nil))


(defmacro listing (name source (rowname &optional index) &body element)
  `(listing% ,name
             ,source
             (lambda (,rowname ,@(csplice index index)) (declare (ignorable ,rowname ,@(csplice index index))) ,@element)))

(defmacro listing* (source (rowname &optional index) &body element)
  `(listing% (gensym "LISTING") 
            ,source
            (lambda (,rowname ,@(csplice index index)) (declare (ignorable ,rowname ,@(csplice index index))) ,@element)))

