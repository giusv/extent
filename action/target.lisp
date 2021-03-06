(defaction (target ((pose pose)))
  (to-list () `(target :pose ,pose :pre ,(synth to-list pre) :post ,(synth to-list post)))
  ;; (to-req () (hcat (text "effettua una transizione verso ") (synth to-url pose)))
  (to-html () (multitags (text "effettua una transizione verso il seguente URL:") 
                         (a (list :href (concatenate 'string "#" (synth to-string (synth to-url pose) 0))) (code nil (synth to-url pose)))
                         (dlist pre (text "Precondizione: ") (synth to-html pre)
                                post (text "Postcondizione:") (synth to-html post)))))

(defaction (show-modal ((modal modal)))
  (to-list () `(show-modal :modal ,(synth to-list modal)))
  (to-html () (multitags (text "mostra la seguente finestra modale:")
                         (p nil (synth to-html modal (void-url)))
                         (dlist pre (text "Precondizione: ") (synth to-html pre)
                                post (text "Postcondizione:") (synth to-html post)))))
