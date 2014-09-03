;;;; #lang racket
;;;;
;;;; SICP Chapter 3.3.2 Representing Queues
;;;;
;;;; Author: @uents on twitter
;;;;
;;;; Usage:
;;;;
;;;; 0. Setup Geiser on Emacs
;;;;     M-x package-install geiser
;;;;
;;;; 1. Download source codes
;;;;     git clone https://github.com/uents/sicp.git
;;;;
;;;; 2. Start Emacs and Racket REPL (M-x run-racket)
;;;;
;;;; 3. Executes below commands on Racket REPL
;;;;
;;;;   (load "ch3.3.2.scm")
;;;;   ....
;;;;

(load "misc.scm")

;; ミュータブルなデータを使用するために必要
(require r5rs)


;;; FIFO
(define (make-queue) (cons '() '()))

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue)))) 

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue))) 


;;; ex 3.21

; racket@> (define q1 (make-queue))
; 
; racket@> (insert-queue! q1 'a)
; (mcons (mcons 'a '()) (mcons 'a '()))
; 
; racket@> (insert-queue! q1 'b)
; (mcons (mcons 'a (mcons 'b '())) (mcons 'b '()))
; 
; racket@> (delete-queue! q1)
; (mcons (mcons 'b '()) (mcons 'b '()))
; 
; racket@> (delete-queue! q1)
; (mcons '() (mcons 'b '()))

(define (print-queue queue)
  (begin
	(display (front-ptr queue) (current-error-port))
	(newline (current-error-port))))


;;; ex 3.22

(define (make-queue)
  (let ((front-ptr nil)
		(rear-ptr nil))
	(define (empty-queue?)
	  (null? front-ptr))
	(define (insert-queue! item)
	  (let ((new-pair (cons item nil)))
		(if (empty-queue?)
			(begin
			  (set! front-ptr new-pair)
			  (set! rear-ptr new-pair))
			(begin
			  (set-cdr! rear-ptr new-pair)
			  (set! rear-ptr new-pair)))))
	(define (delete-queue!)
	  (if (empty-queue?)
		  (error "DELETE! called with an empty queue" queue)
		  (begin
			(let ((item (car front-ptr)))
			  (set! front-ptr (cdr front-ptr))
			  item))))
	(define (print-queue)
	  (begin
		(display front-ptr (current-error-port))
		(newline (current-error-port))))

	(define (dispatch m)
	  (cond ((eq? m 'insert-proc!) insert-queue!)
			((eq? m 'delete-proc!) delete-queue!)
			((eq? m 'print-proc) print-queue)
			(else (error "Unknown operation -- QUEUE" m))))
	dispatch))


; racket@> (define q1 (make-queue))
; racket@> ((q1 'insert-proc!) 'a)
; racket@> ((q1 'print-proc))
; (a)
; racket@> ((q1 'insert-proc!) 'b)
; racket@> ((q1 'print-proc))
; (a b)
; racket@> ((q1 'delete-proc!))
; 'a
; racket@> ((q1 'print-proc))
; (b)
; racket@> ((q1 'delete-proc!))
; 'b
; racket@> ((q1 'print-proc))
; ()
