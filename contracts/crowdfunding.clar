;; Define error constants
(define-constant ERR_INVALID_GOAL u200)
(define-constant ERR_CAMPAIGN_NOT_FOUND u201)
(define-constant ERR_CAMPAIGN_ALREADY_EXISTS u202)
(define-constant ERR_GOAL_NOT_REACHED u203)
(define-constant ERR_UNAUTHORIZED u204)
(define-constant ERR_CAMPAIGN_ENDED u205)

;; Define the contract
(define-data-var campaign-counter uint u0)
(define-map campaigns uint
  { creator: principal, goal: uint, raised: uint, end-block: uint, active: bool })
(define-map contributions { campaign-id: uint, contributor: principal } uint)

;; Function to create a campaign
(define-public (create-campaign (goal uint) (duration uint))
  (let ((campaign-id (var-get campaign-counter))
        (caller tx-sender))
    (if (<= goal u0)
        (err ERR_INVALID_GOAL)
        (begin
          (var-set campaign-counter (+ campaign-id u1))
          (map-set campaigns campaign-id
            { creator: caller, goal: goal, raised: u0, end-block: (+ block-height duration), active: true })
          (ok campaign-id)))))
