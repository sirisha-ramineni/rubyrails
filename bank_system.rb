# Simple Bank Account Management System

# Base class for all bank accounts
class BankAccount
  attr_reader :account_number, :balance, :account_holder
  
  def initialize(account_number, account_holder, initial_balance = 0)
    @account_number = account_number
    @account_holder = account_holder
    @balance = initial_balance
    @transaction_history = []
  end
  
  def deposit(amount)
    if amount > 0
      @balance += amount
      add_transaction("Deposit", amount)
      puts "Deposited $#{amount}. New balance: $#{@balance}"
    else
      puts "Invalid deposit amount"
    end
  end
  
  def withdraw(amount)
    if amount > 0 && amount <= @balance
      @balance -= amount
      add_transaction("Withdrawal", -amount)
      puts "Withdrew $#{amount}. New balance: $#{@balance}"
    else
      puts "Insufficient funds or invalid amount"
    end
  end
  
  def display_balance
    puts "Account: #{@account_number}"
    puts "Holder: #{@account_holder}"
    puts "Balance: $#{@balance}"
  end
  
  def display_transactions
    puts "\nTransaction History for #{@account_holder}:"
    @transaction_history.each do |transaction|
      puts "#{transaction[:type]}: $#{transaction[:amount]} (#{transaction[:date]})"
    end
  end
  
  private
  
  def add_transaction(type, amount)
    @transaction_history << {
      type: type,
      amount: amount.abs,
      date: Time.now.strftime("%Y-%m-%d %H:%M:%S")
    }
  end
end

# Savings Account with interest
class SavingsAccount < BankAccount
  attr_reader :interest_rate
  
  def initialize(account_number, account_holder, initial_balance = 0, interest_rate = 0.02)
    super(account_number, account_holder, initial_balance)
    @interest_rate = interest_rate
  end
  
  def add_interest
    interest = @balance * @interest_rate
    @balance += interest
    add_transaction("Interest", interest)
    puts "Interest added: $#{interest}. New balance: $#{@balance}"
  end
  
  def withdraw(amount)
    if @balance - amount >= 100  # Minimum balance requirement
      super(amount)
    else
      puts "Cannot withdraw. Minimum balance of $100 required."
    end
  end
end

# Checking Account with overdraft protection
class CheckingAccount < BankAccount
  attr_reader :overdraft_limit
  
  def initialize(account_number, account_holder, initial_balance = 0, overdraft_limit = 500)
    super(account_number, account_holder, initial_balance)
    @overdraft_limit = overdraft_limit
  end
  
  def withdraw(amount)
    if @balance - amount >= -@overdraft_limit
      @balance -= amount
      add_transaction("Withdrawal", -amount)
      puts "Withdrew $#{amount}. New balance: $#{@balance}"
    else
      puts "Withdrawal denied. Overdraft limit exceeded."
    end
  end
end

# Bank class to manage multiple accounts
class Bank
  def initialize(name)
    @name = name
    @accounts = {}
    @next_account_number = 1001
  end
  
  def create_savings_account(account_holder, initial_balance = 0)
    account_number = generate_account_number
    account = SavingsAccount.new(account_number, account_holder, initial_balance)
    @accounts[account_number] = account
    puts "Created savings account #{account_number} for #{account_holder}"
    account
  end
  
  def create_checking_account(account_holder, initial_balance = 0)
    account_number = generate_account_number
    account = CheckingAccount.new(account_number, account_holder, initial_balance)
    @accounts[account_number] = account
    puts "Created checking account #{account_number} for #{account_holder}"
    account
  end
  
  def find_account(account_number)
    @accounts[account_number]
  end
  
  def list_all_accounts
    puts "\n=== #{@name} - All Accounts ==="
    @accounts.each do |account_number, account|
      puts "Account: #{account_number} | Holder: #{account.account_holder} | Balance: $#{account.balance}"
    end
  end
  
  def total_deposits
    @accounts.values.sum(&:balance)
  end
  
  def display_bank_summary
    puts "\n=== #{@name} Summary ==="
    puts "Total Accounts: #{@accounts.length}"
    puts "Total Deposits: $#{total_deposits}"
    puts "Savings Accounts: #{@accounts.values.count { |acc| acc.is_a?(SavingsAccount) }}"
    puts "Checking Accounts: #{@accounts.values.count { |acc| acc.is_a?(CheckingAccount) }}"
  end
  
  private
  
  def generate_account_number
    @next_account_number += 1
  end
end

# Main program execution
if __FILE__ == $0
  # Create a bank
  my_bank = Bank.new("MyBank")
  
  # Create accounts
  puts "=== Creating Accounts ==="
  savings1 = my_bank.create_savings_account("John Doe", 1000)
  checking1 = my_bank.create_checking_account("Jane Smith", 500)
  savings2 = my_bank.create_savings_account("Bob Wilson", 2500)
  
  # Perform transactions
  puts "\n=== Performing Transactions ==="
  savings1.deposit(500)
  savings1.withdraw(200)
  savings1.add_interest
  
  checking1.deposit(300)
  checking1.withdraw(100)
  checking1.withdraw(800)  # This should work due to overdraft protection
  
  savings2.deposit(1000)
  savings2.withdraw(2500)  # This should fail due to minimum balance
  
  # Display account information
  puts "\n=== Account Information ==="
  savings1.display_balance
  checking1.display_balance
  savings2.display_balance
  
  # Show transaction history
  savings1.display_transactions
  checking1.display_transactions
  
  # Bank summary
  my_bank.display_bank_summary
  my_bank.list_all_accounts
end 