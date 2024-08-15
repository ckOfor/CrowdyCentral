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

;; Function to contribute to a campaign
(define-public (contribute (campaign-id uint) (amount uint))
  (let ((campaign (map-get? campaigns campaign-id))
        (caller tx-sender))
    (if (is-none campaign)
        (err ERR_CAMPAIGN_NOT_FOUND)
        (let ((campaign-data (unwrap campaign (err ERR_CAMPAIGN_NOT_FOUND))))
          (if (or (not (get active campaign-data)) (> block-height (get end-block campaign-data)))
              (err ERR_CAMPAIGN_ENDED)
              (begin
                (try! (stx-transfer? amount caller (as-contract tx-sender)))
                (map-set campaigns campaign-id
                  { creator: (get creator campaign-data), goal: (get goal campaign-data),
                    raised: (+ (get raised campaign-data) amount),
                    end-block: (get end-block campaign-data), active: true })
                (map-set contributions { campaign-id: campaign-id, contributor: caller } amount)
                (ok true)))))))
