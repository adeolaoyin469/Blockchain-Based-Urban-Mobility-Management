;; Usage Tracking Contract
;; Monitors transportation utilization in the urban mobility system

(define-data-var admin principal tx-sender)

;; Data structure for usage records
(define-map usage-records uint
  {
    vehicle-id: (string-utf8 50),
    route-id: uint,
    start-time: uint,
    end-time: uint,
    distance: uint,
    passenger-count: uint,
    service-provider: principal
  }
)

;; Counter for usage record IDs
(define-data-var record-id-counter uint u0)

;; Public function to record a new usage
(define-public (record-usage
    (vehicle-id (string-utf8 50))
    (route-id uint)
    (start-time uint)
    (end-time uint)
    (distance uint)
    (passenger-count uint)
    (service-provider principal))
  (let ((new-id (+ (var-get record-id-counter) u1)))
    (begin
      ;; Check if end time is after start time
      (asserts! (> end-time start-time) (err u1))

      ;; Increment record counter
      (var-set record-id-counter new-id)

      ;; Store the usage record
      (map-set usage-records new-id
        {
          vehicle-id: vehicle-id,
          route-id: route-id,
          start-time: start-time,
          end-time: end-time,
          distance: distance,
          passenger-count: passenger-count,
          service-provider: service-provider
        }
      )

      (ok new-id)
    )
  )
)

;; Public function to get usage record details
(define-read-only (get-usage-record (record-id uint))
  (map-get? usage-records record-id)
)

;; Public function to get total records
(define-read-only (get-total-records)
  (var-get record-id-counter)
)

;; Public function to get vehicle usage statistics (simplified)
(define-read-only (get-vehicle-stats (vehicle-id (string-utf8 50)))
  (let ((total-distance u0)
        (total-passengers u0)
        (total-trips u0))
    ;; In a real implementation, this would iterate through records
    ;; and calculate actual statistics
    {
      total-distance: total-distance,
      total-passengers: total-passengers,
      total-trips: total-trips
    }
  )
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u1))
    (ok (var-set admin new-admin))
  )
)
