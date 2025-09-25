class Account < ApplicationRecord
  belongs_to :bank
  has_many :transactions, dependent: :destroy
  
  validates :account_number, presence: true, uniqueness: true
  validates :account_holder, presence: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_type, presence: true, inclusion: { in: %w[savings checking] }
  
  before_validation :generate_account_number, on: :create
  before_validation :set_default_balance, on: :create
  
  scope :savings, -> { where(account_type: 'savings') }
  scope :checking, -> { where(account_type: 'checking') }
  
  def deposit(amount)
    return false if amount <= 0
    
    self.balance += amount
    if save
      transactions.create!(
        transaction_type: 'deposit',
        amount: amount,
        description: "Deposit of $#{amount}"
      )
      true
    else
      false
    end
  end
  
  def withdraw(amount)
    return false if amount <= 0
    
    case account_type
    when 'savings'
      return false if balance - amount < 100 # Minimum balance requirement
    when 'checking'
      return false if balance - amount < -500 # Overdraft limit
    end
    
    self.balance -= amount
    if save
      transactions.create!(
        transaction_type: 'withdrawal',
        amount: amount,
        description: "Withdrawal of $#{amount}"
      )
      true
    else
      false
    end
  end
  
  def add_interest(rate = 0.02)
    return false unless account_type == 'savings'
    
    interest = balance * rate
    self.balance += interest
    if save
      transactions.create!(
        transaction_type: 'interest',
        amount: interest,
        description: "Interest added: $#{interest.round(2)}"
      )
      true
    else
      false
    end
  end
  
  def display_balance
    {
      account_number: account_number,
      account_holder: account_holder,
      balance: balance,
      account_type: account_type
    }
  end
  
  def recent_transactions(limit = 10)
    transactions.order(created_at: :desc).limit(limit)
  end
  
  private
  
  def generate_account_number
    self.account_number ||= "#{bank_id}#{rand(1000..9999)}"
  end
  
  def set_default_balance
    self.balance ||= 0
  end
end
