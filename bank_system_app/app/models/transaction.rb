class Transaction < ApplicationRecord
  belongs_to :account
  
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal interest transfer] }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  
  scope :deposits, -> { where(transaction_type: 'deposit') }
  scope :withdrawals, -> { where(transaction_type: 'withdrawal') }
  scope :interest, -> { where(transaction_type: 'interest') }
  scope :transfers, -> { where(transaction_type: 'transfer') }
  scope :recent, -> { order(created_at: :desc) }
  
  def formatted_amount
    case transaction_type
    when 'deposit', 'interest'
      "+$#{amount}"
    when 'withdrawal', 'transfer'
      "-$#{amount}"
    else
      "$#{amount}"
    end
  end
  
  def formatted_date
    created_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end
