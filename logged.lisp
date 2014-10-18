(defun read-temps()
  (loop for sensor in '("outdoor" "garage" "kitchen" "living-room" "office" "kids")
       for last in prev
     :collect
       (let ((res (handler-case
		      (with-open-file (f (string-concat "temperatures/" sensor) :direction :input)
			(read f nil nil))
		    (error (e) (format nil "Error ~E" e) nil))))
	 (cond
	   ((null res) last)
	   ((> (abs (- res last))1) (+ last (/ (abs(- res last)) (- res last)))) 
	   (t res)))))

(defun get-info( prev)
  (loop for sensor in '("outdoor" "garage" "kitchen" "living-room" "office" "kids")
       for last in prev
     :collect
       (let ((res (handler-case
		      (with-open-file (f (string-concat "temperatures/" sensor) :direction :input)
			(read f nil nil))
		    (error (e) (format nil "Error ~E" e) nil))))
	 (cond
	   ((null res) last)
	   ((> (abs (- res last))1) (+ last (/ (abs(- res last)) (- res last)))) 
	   (t res)))))

(defun save-current(current)
  (delete-file "prev.lisp")
  (with-open-file (f "prev.lisp" :direction :output)
      (format f "(defparameter *prev* '~S)" current)))

(defun main()
  (load "prev.lisp")
  (let ((res (get-info *prev*)))
    (save-current res)
    (format t "~{~F ~}~%" res)))
(main)