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
