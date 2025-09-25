class AccountsController < ApplicationController
  before_action :set_bank
  before_action :set_account, only: [:show, :edit, :update, :destroy, :deposit, :withdraw, :add_interest]

  def index
    @accounts = @bank.accounts.includes(:transactions)
  end

  def show
    @transactions = @account.recent_transactions(20)
  end

  def new
    @account = @bank.accounts.build
  end

  def create
    @account = @bank.accounts.build(account_params)
    
    if @account.save
      redirect_to [@bank, @account], notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to [@bank, @account], notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to bank_accounts_path(@bank), notice: 'Account was successfully deleted.'
  end

  def deposit
    amount = params[:amount].to_f
    
    if @account.deposit(amount)
      redirect_to [@bank, @account], notice: "Successfully deposited $#{amount}"
    else
      redirect_to [@bank, @account], alert: 'Invalid deposit amount'
    end
  end

  def withdraw
    amount = params[:amount].to_f
    
    if @account.withdraw(amount)
      redirect_to [@bank, @account], notice: "Successfully withdrew $#{amount}"
    else
      redirect_to [@bank, @account], alert: 'Insufficient funds or invalid amount'
    end
  end

  def add_interest
    if @account.add_interest
      redirect_to [@bank, @account], notice: 'Interest added successfully'
    else
      redirect_to [@bank, @account], alert: 'Interest can only be added to savings accounts'
    end
  end

  private

  def set_bank
    @bank = Bank.find(params[:bank_id])
  end

  def set_account
    @account = @bank.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:account_holder, :balance, :account_type)
  end
end
