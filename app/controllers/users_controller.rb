class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Acceso denegado."
      end
    end
  end

  def new
     @user = User.new
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "Usuario actualizado."
    else
      redirect_to users_path, :alert => "No se logro actualizar el usuario."
    end
  end
	
	def create
    @user = User.new(secure_params)

    if @user.save
      redirect_to users_path, :flash => { :success => 'El usuario fue creado satisfactoriamente.' }
    else
      render :action => 'new'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "Usuario borrado."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to "/", :alert => "Accesso denegado."
    end
  end

  def secure_params
    params.require(:user).permit(:role, :name, :email, :password, :password_confirmation)
  end

end
