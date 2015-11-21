class SubsController < ApplicationController
  before_action :prohibit_non_mods, only: [:edit, :destroy, :update]

  before_action :must_be_logged_in, except: [:show, :index]

  def index
    @subs = Sub.all
    render :index
  end

  def show
    render :show
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update_attributes(sub_params) # like save - will return true or false
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  private
  def prohibit_non_mods
    return if current_user.is_moderator?(current_sub)
    redirect_to sub_url
  end

  def must_be_logged_in
    return if current_user
    flash[:errors] = ["Please log in before creating a sub!"]
    redirect_to new_session_url
  end

  def current_sub
    @current_sub = Sub.find(params[:id])
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
