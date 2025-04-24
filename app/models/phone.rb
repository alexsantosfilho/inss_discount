class Phone < ApplicationRecord
  belongs_to :employee

  enum :phone_type, { personal: "personal", reference: "reference" }

  validates :number, presence: true
end
