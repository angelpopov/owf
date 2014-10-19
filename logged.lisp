(defvar *sensors* '("outdoor" "garage" "kitchen" "living-room" "office" "kids"))
(defun read-sensor(sensor)
  (handler-case
      (with-open-file (f (string-concat "~/temperatures/" sensor) :direction :input)
	(read f nil nil))
    (error (e) (format nil "Error ~E" e) nil)))
(defun filter-latest(last prev)
  (cond
    ((null last) prev)
    ((and prev (> (abs (- prev last))1)) (+ last (/ (abs(- prev last)) (- prev last))))
    (t last)))

(defun save-current(current)
  (delete-file "~/prev.lisp")
  (with-open-file (f "~/prev.lisp" :direction :output)
      (format f "(defparameter *prev* '~S)" current)))

(defun main()
  (load "~/prev.lisp")
  (let ((res (mapcar #'filter-latest (mapcar #'read-sensor *sensors*) *prev*)))
    ;(save-current res)
    (format t "~{~F ~}~%" res)))
(main)