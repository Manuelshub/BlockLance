
;; title: block_lance
;; version: 0.0.1
;; summary: A decentralized freelance platform
;; description: Freelance Payment Platform Smart Contract 

;; constants
;; Contract Owner (deployer) - has administrative rights
(define-constant CONTRACT-OWNER tx-sender)

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-JOB (err u101))
(define-constant ERR-INSUFFICIENT-FUNDS (err u102))
(define-constant ERR-JOB-ALREADY-EXISTS (err u103))
(define-constant ERR-JOB-NOT-FOUND (err u104))
(define-constant ERR-INVALID-STATUS (err u105))
(define-constant ERR-INVALID-DESCRIPTION (err u106))
(define-constant ERR-INVALID-PAYMENT (err u107))
(define-constant ERR-INVALID-MILESTONE (err u108))

;; Job Status enum
(define-constant JOB-STATUS-CREATED u0)
(define-constant JOB-STATUS-IN-PROGRESS u1)
(define-constant JOB-STATUS-COMPLETED u2)
(define-constant JOB-STATUS-DISPUTED u3)
(define-constant JOB-STATUS-PAID u4)

;; data maps
;; Job Structure
(define-map jobs
    {job-id: uint}
    {
        client: principal,
        freelancer: principal,
        description: (string-utf8 500),
        total-payment: uint,
        status: uint,
        milestones: (list 10 {description: (string-utf8 200), payment: uint, completed: bool})
    }
)

;; Job counter
(define-data-var job-counter uint u0)

;; Validation functions
(define-private (is-valid-description (desc (string-utf8  500)))
    (and
        (> (len desc) u0)
        (<= (len desc) u500)
    )
)

(define-private (is-valid-milestone-description (desc (string-utf8 200)))
    (and
        (> (len desc) u0)
        (<= (len desc) u200)
    )
)

(define-private (is-milestone-valid (milestone {description: (string-utf8 200), payment: uint, completed: bool}))
    (and
        (is-valid-milestone-description (get description milestone))
        (> (get payment milestone) u0)
    )
)

(define-private (validate-milestones-helper (milestone {description: (string-utf8 200), payment: uint, completed: bool}) (is-valid (response bool bool))
)
    (if (is-ok is-valid)
        (and (unwrap-panic is-valid) (is-milestone-valid milestone))
        false
    )
)

(define-private (is-valid-milestones (milestones (list 10 {description: (string-utf8 200), payment: uint, completed: bool})))
    (and
        ;; Ensure at least one milestone
        (> (len milestones) u0)

        ;; Validate each milestone
        (is-eq
            (len (filter is-milestone-valid milestones))
            (len milestones)
        )
    )
)

;; public functions
;; Create a new job
(define-public (create-job 
    (freelancer principal)
    (description (string-utf8 500))
    (total-payment uint)
    (milestones (list 10 {description: (string-utf8 200), payment: uint, completed: bool}))
)
    (begin
        ;; Validate inputs
        (asserts! (not (is-eq freelancer tx-sender)) ERR-INVALID-JOB) ;; Freelancer cannot be the same as client, Prevent self-hiring
        (asserts! (is-valid-description description) ERR-INVALID-DESCRIPTION)
        (asserts! (> total-payment u0) ERR-INVALID-PAYMENT)
        (asserts! (is-valid-milestones milestones) ERR-INVALID-MILESTONE)

        ;; Ensure total milestone payments match total job payment
        (let ((milestone-total (fold + (map get-milestone-payment milestones) u0)))
            (asserts! (is-eq milestone-total total-payment) ERR-INVALID-JOB)

            ;; Increment job counter
            (var-set job-counter (+ (var-get job-counter) u1))

            ;; Create job Entry
            (map-set jobs
                {job-id: (var-get job-counter)}
                {
                    client: tx-sender,
                    freelancer: freelancer,
                    description: description,
                    total-payment: total-payment,
                    status: JOB-STATUS-CREATED,
                    milestones: milestones
                }
            )

            (ok (var-get job-counter))
        )
    )
)

;; read only functions
;; Helper function to get milestone payment
(define-read-only (get-milestone-payment (milestone {description: (string-utf8 200), payment: uint, completed: bool}))
    (get payment milestone)
)

;; Start job
(define-public (start-job (job-id uint))
    (let
        ((job (unwrap! (map-get? jobs {job-id: job-id}) ERR-JOB-NOT-FOUND))
        )

        ;; Input Validation
        (asserts! (> job-id u0) ERR-INVALID-JOB)

        ;; Only client can start the job
        (asserts! (is-eq tx-sender (get client job)) ERR-NOT-AUTHORIZED)

        ;; Ensure job is in CREATED status
        (asserts! (is-eq (get status job) JOB-STATUS-CREATED) ERR-INVALID-STATUS)

        ;; Update job status
        (map-set jobs 
            {job-id: job-id}
            (merge job {status: JOB-STATUS-IN-PROGRESS})    
        )

        (ok true)
    )
)

;; Read job details
(define-read-only (get-job-details (job-id uint))
    (map-get? jobs {job-id: job-id})
)