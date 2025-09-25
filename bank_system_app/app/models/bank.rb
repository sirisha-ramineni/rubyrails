class Bank < ApplicationRecord
  has_many :accounts, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  
  def total_deposits
    accounts.sum(:balance)
  end
  
  def savings_accounts
    accounts.where(account_type: 'savings')
  end
  
  def checking_accounts
    accounts.where(account_type: 'checking')
  end
  
  def account_count
    accounts.count
  end
  
  def display_summary
    {
      name: name,
      total_accounts: account_count,
      total_deposits: total_deposits,
      savings_accounts: savings_accounts.count,
      checking_accounts: checking_accounts.count
    }
  end
end
