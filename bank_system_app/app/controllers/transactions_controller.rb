class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.includes(:account).recent.limit(50)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end
end
