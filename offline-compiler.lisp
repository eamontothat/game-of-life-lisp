(defvar *board* 0)
(defvar *neighbors-distance* 0)
(defvar *size* 0)
(defvar *steady-neighbors* 0)
(defvar *live-people* 0)
(defvar *test-case* 0)
(defvar *new-board* 0)
(defvar *2dboard* 0)
(defvar *starting-tiles* 0)

;Ripped from the big brain boys at stack overflow.
;https://stackoverflow.com/questions/49490551/how-to-shuffle-list-in-lisp
(defun nshuffle (sequence)
    (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
            (elt sequence (1- i))))
sequence)

(defun checkDead (posx posy)
    (setq *live-people* 0)
    
    (dotimes (*relative-x* (+ (* *neighbors-distance* 2) 1))
        (dotimes (*relative-y*  (+ (* *neighbors-distance* 2) 1))
            ;(princ (aref *board* (mod (- (+ *relative-x* posx) *neighbors-distance*) *size*) (mod (- (+ *relative-y* posy) *neighbors-distance*) *size*)))
            (if (equal (aref *board* (mod (- (+ *relative-x* posx) *neighbors-distance*) *size*) (mod (- (+ *relative-y* posy) *neighbors-distance*) *size*)) "A")
                (setq *live-people* (+ *live-people* 1))
            )
        )
    )
    ;(princ *live-people*)
    (if (equal nil (find *live-people* *steady-neighbors*))
        (setq *test-case* -1)
        (setq *test-case* (find *live-people* *steady-neighbors*))
    )
    
    (if (= *live-people* *test-case*)
        (setf (aref *new-board* posx posy) "A")
        (setf (aref *new-board* posx posy) "d")
    )
)

(defun checkStay (posx posy)
    (setq *live-people* 0)
    
    (dotimes (*relative-x* (+ (* *neighbors-distance* 2) 1))
        (dotimes (*relative-y*  (+ (* *neighbors-distance* 2) 1))
            (if (equal (aref *board* (mod (- (+ *relative-x* posx) *neighbors-distance*) *size*) (mod (- (+ *relative-y* posy) *neighbors-distance*) *size*)) "A")
                (setq *live-people* (+ *live-people* 1))
            )
            (if (and (equal (- (+ *relative-x* posx) *neighbors-distance*) posx) (equal (- (+ *relative-y* posy) *neighbors-distance*) posy))
                (setq *live-people* (- *live-people* 1))
                ;(princ "hi")
            )
        )
    )
    (if (equal nil (find *live-people* *steady-neighbors*))
        (setq *test-case* -1)
        (setq *test-case* (find *live-people* *steady-neighbors*))
    )
    
    (if (= *live-people* *test-case*)
        (setf (aref *new-board* posx posy) "A")
        (setf (aref *new-board* posx posy) "d")
    )
)

(princ "Enter the size of the board: ")
(setq *size* (read))

(princ "Enter the number of live neighbors for a live cell to stay alive: ")
(setq *steady-neighbors* (let ((string (read)))
  (loop :for (integer position) := (multiple-value-list 
                                    (parse-integer string
                                                   :start (or position 0)
                                                   :junk-allowed t))
        :while integer
        :collect integer))
)

(princ "Enter the number of live neighbors for a dead cell to become alive: ")
(setq *necro-neighbors* (let ((string (read)))
  (loop :for (integer position) := (multiple-value-list 
                                    (parse-integer string
                                                   :start (or position 0)
                                                   :junk-allowed t))
        :while integer
        :collect integer))
)

(princ "Enter the distance for the neighbor rule: ")
(loop
    (setq *neighbors-distance* (read))
    (if (< *neighbors-distance* *size*)
        (return 0)
        (princ "ERROR: Neighbor distance bigger than board size; re-enter: ")
    )
)


(princ "Enter number of live tiles to start with: ")
(loop
    (setq *starting-tiles* (read))
    (if (< *starting-tiles* (* *size* *size*))
        (return *starting-tiles*)
    )
    (princ "ERROR: More live tiles than board size; re-enter: ")
)

(setq *board* (make-array (* *size* *size*)))
(setq *2dboard* (make-array (list *size* *size*)))
(setq *new-board* (make-array (list *size* *size*)))
(dotimes (i (* *size* *size*)) 
    (if (< i *starting-tiles*)
        (setf (aref *board* i) "A")
    (setf (aref *board* i) "d")
    )
)

(nshuffle *board*)

(dotimes (i *size*)
    (dotimes (j *size*)
        (setf (aref *2dboard* i j) (aref *board* (+ (* i *size*) j)))
        (setf (aref *new-board* i j) (aref *board* (+ (* i *size*) j)))
    )
)

(setq *board* *2dboard*)

(defvar *steps* 0)
(loop
    (dotimes (i *size*)
        (dotimes (j *size*)
            (if (equal (aref *board* i j) "d")
                (progn
                    (checkDead i j)
                )
                (progn
                    (checkStay i j)
                )
            )
        )
    )
    (if (= *steps* 100)
        (return 0)
    )
    (setq *board* *new-board*)
    (setq *steps* (+ *steps* 1))
 
    (princ "STEP ")
    (princ *steps*)
    (terpri)
    (dotimes (i *size*)
        (dotimes (j *size*)
            (princ (aref *new-board* i j))
            (princ " ")
        )
        (terpri)
    )
    (princ "Press \"ENTER\" to continue: ")
    (terpri)
    (terpri)
    (read-line)
)
