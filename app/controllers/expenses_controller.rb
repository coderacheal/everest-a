class ExpensesController < ApplicationController
  # before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :set_category, only: %i[index new create]

  # GET /expenses or /expenses.json
  def index
    @category_expenses = Expense.where(category_id: params[:category_id])
    @expenses = @category.expenses.includes(:user).order(created_at: :desc)
    @total_amount = @expenses.sum(:amount)
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    @category = Category.find(params[:category_id])
    @expense = @category.expenses.find(params[:id])
  end
  

  # GET /expenses/new
  def new
    @expense = Expense.new
    # @category_expenses = @category.expenses.to_a
    # @category_expenses = Expense.where(category_id: params[:category_id])
    @category_expenses = @category.expenses.to_a
    @total_amount = @category_expenses.sum(&:amount)
  end


  # GET /expenses/1/edit
  def edit
    @category = Category.find(params[:category_id])
    @expense = Expense.find(params[:id])
  end

  # POST /expenses or /expenses.json
  def create
    @expense = @category.expenses.build(expense_params)
    @category_expenses = @category.expenses.to_a
    total_expenses_amount = @category_expenses.sum(&:amount)

    if total_expenses_amount > @category.limit
      render :new
    else
      if @expense.save
        @category.expenses << @expense
        redirect_to category_expenses_path
      else
        render :new
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    @expense = Expense.find(params[:id])
    @category = Category.find(params[:category_id]) # Fetch the associated category
  
    if @category
      @category_expenses = @category.expenses.to_a
      total_expenses_amount = @category_expenses.sum(&:amount) - (@expense.amount.to_i || 0)
  
      if total_expenses_amount + params[:expense][:amount].to_i <= @category.limit
        if @expense.update(expense_params)
          redirect_to category_expenses_path, notice: "Expense updated successfully."
        else
          flash.now[:alert] = "Failed to update expense."
          render :edit
        end
      else
        flash.now[:alert] = "Updating this expense would exceed the category limit."
        render :edit
      end
    else
      flash.now[:alert] = "Category not found."
      render :edit
    end
  end
  
  
  
  
  

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to category_expense_path
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:category_id])
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount).merge(author_id: current_user.id)
  end
  # Only allow a list of trusted parameters through.
end


# def set_category
#   @category = Category.find(params[:category_id])
# end
