class Appointment < ApplicationRecord

  APPOINTMENT_STATUS = ['pending', 'confirmed', 'canceled', 'rescheduled']

  #scopes
  scope :pending, -> { where(status: APPOINTMENT_STATUS[0]) }
  scope :rescheduled, -> { where(status: APPOINTMENT_STATUS[3]) }
  scope :canceled, -> { where(status: APPOINTMENT_STATUS[2]) }
  scope :confirmed, -> { where(status: APPOINTMENT_STATUS[1]) }
  scope :with_status, -> (status) { where(status: status) }

  #associations
  belongs_to :offer
  belongs_to :stylist, inverse_of: :appointments #via offer
  belongs_to :user

  #validations
  validates :user_id, presence: true
  validates :offer_id, presence: true
  validates_uniqueness_of :time, scope: [:offer_id, :date], conditions: -> { where.not(status: [APPOINTMENT_STATUS[2], APPOINTMENT_STATUS[3]]) }, if: Proc.new { |a| a.status != APPOINTMENT_STATUS[3] and a.date and a.time }

  #callbacks
  before_validation :appointment_date_time
  before_create :add_initial_call_status
  after_create :alert_on_appointment_creation
  before_update :status_change_alert
  after_create :generate_barcode
  before_update :refund_if_cancelled_by_s_or_a

  # the appointment form has a single date time field and date and time is being seperated here
  def appointment_date_time
  end

  # admin follows up with user a
  def add_initial_call_status
  end

  # admin updates in backend if call was made, not made or should be made again because user did not answer
  def toggle_call_status
  end

  #if a confirmed appointment is cancelled by admin side, user is entitled to get a refund
  def refund_if_cancelled_by_s_or_a
  end

  #send user notification on phone about new appointment created
  def alert_on_appointment_creation
  end

  #alert user whenever appointment status changed
  def status_change_alert
  end

  #reminders to sent to user before appointment time
  def self.appointment_alerts
  end

  #method called by appointment_alerts method above
  def self.send_user_appointment_alert(user, alert_time, alert_type)
  end

  #method called by send_user_appointment_alert method above
  def self.send_appointment(user, appointment)
  end

  #generating barcode to be displayed on appointment receipt
  def generate_barcode
  end

  #getting barcode image to show in
  def get_barcode
  end

end