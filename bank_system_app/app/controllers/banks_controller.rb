class BanksController < ApplicationController
  before_action :set_bank, only: [:show, :edit, :update, :destroy]

  def index
    @banks = Bank.all
  end

  def show
    @accounts = @bank.accounts.includes(:transactions)
  end

  def new
    @bank = Bank.new
  end

  def create
    @bank = Bank.new(bank_params)
    
    if @bank.save
      redirect_to @bank, notice: 'Bank was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bank.update(bank_params)
      redirect_to @bank, notice: 'Bank was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bank.destroy
    redirect_to banks_url, notice: 'Bank was successfully deleted.'
  end

  private

  def set_bank
    @bank = Bank.find(params[:id])
  end

  def bank_params
    params.require(:bank).permit(:name)
  end
end
