class Procedure < ActiveRecord::Base

  STATUS_TYPES = %w(complete incomplete).freeze

  has_paper_trail
  acts_as_paranoid

  has_one :protocol,    through: :appointment
  has_one :arm,         through: :appointment
  has_one :participant, through: :appointment
  has_one :visit_group, through: :appointment
  has_one :task,        as: :assignable

  belongs_to :appointment
  belongs_to :visit

  has_many :notes, as: :notable
  has_many :tasks, as: :assignable

  validates_inclusion_of :status, in: STATUS_TYPES,
                                  if: Proc.new { |procedure| procedure.status.present? }

  accepts_nested_attributes_for :notes

  scope :untouched,   -> { where('status IS NULL')              }
  scope :incomplete,  -> { where('completed_date IS NULL')      }
  scope :complete,    -> { where('completed_date IS NOT NULL')  }

  def self.billing_display
    [["R", "research_billing_qty"],
     ["T", "insurance_billing_qty"],
     ["O", "other_billing_qty"]]
  end

  def update_attributes(attributes)
    if attributes[:status].present? &&
        attributes[:status] == "complete" &&
        (incomplete? || status.nil? || reset?)
      attributes.merge!(completed_date: Time.current)
    elsif attributes[:status].blank? &&
        attributes[:status] == ''
      attributes.merge!(completed_date: nil)
    end

    super attributes
  end

  def reset?
    status == ''
  end

  def complete?
    status == 'complete'
  end

  def incomplete?
    status == 'incomplete'
  end

  def destroy
    if status.blank?
      super
    else
      raise ActiveRecord::ActiveRecordError
    end
  end
end
