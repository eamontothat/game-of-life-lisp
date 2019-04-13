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
        ;(terpri)
    )
    (if (= *live-people* *necro-neighbors*)
        (setf (aref *new-board* posx posy) "A")
    )
)

(defun checkStay (posx posy)
    (princ (aref *board* posx posy))
    (princ " (")
    (princ posx)
    (princ ",")
    (princ posy)
    (princ ")")
    (terpri)
)

(princ "Enter the size of the board: ")
(defvar *size* (read))
(princ *size*)
(terpri)

(princ "Enter the number of live neighbors for a live cell to stay alive: ")
(defvar *steady-neighbors* (read))
(princ *steady-neighbors*)
(terpri)

(princ "Enter the number of live neighbors for a dead cell to become alive: ")
(defvar *necro-neighbors* (read))
(princ *necro-neighbors*)
(terpri)

(princ "Enter the distance for the neighbor rule: ")
(loop
    (setq *neighbors-distance* (read))
    (princ *neighbors-distance*)
    (if (< *neighbors-distance* *size*)
        (return *neighbors-distance*)
    )
    (terpri)
    (princ "ERROR: Neighbor distance bigger than board size; re-enter: ")
)
(terpri)


(princ "Enter number of live tiles to start with: ")
(loop
    (setq *starting-tiles* (read))
    (princ *starting-tiles*)
    (if (< *starting-tiles* (* *size* *size*))
        (return *starting-tiles*)
    )
    (terpri)
    (princ "ERROR: More live tiles than board size; re-enter: ")
)
(terpri)

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

(princ *board*)

(terpri)
(dotimes (k 5)
    (print *new-board*)
    (dotimes (i *size*)
        (dotimes (j *size*)
            (if (equal (aref *board* i j) "d")
                (progn
                    (checkDead i j)
                    ;(terpri)
                )
                (progn
                    (checkStay i j)
                )
            )
        )
    )
    (if (= k 5)
        (return 0)
    )
    (terpri)
    
)


