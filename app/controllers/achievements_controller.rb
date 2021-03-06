class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create update destroy edit]
  before_action :check_owner, only: %i[edit update destroy]
  def index
    @achievements = Achievement.get_public_achievements
  end

  def new
    @achievement = Achievement.new
  end

  def create
    service = CreateAchievement.new(achievement_params, current_user)
    service.create
    if service.created?
      redirect_to achievements_path(service.achievement)
    else
      @achievement = service.achievement
      render :new
    end
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def edit; end

  def update
    if @achievement.update(achievement_params)
      flash[:notice] = 'Achievement has been updated'
      redirect_to @achievement
    else
      flash[:notice] = 'Something wrong'
      render :edit
    end
  end

  def destroy
    @achievement.destroy
    redirect_to achievements_path
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :cover_image,
                                        :featured, :privacy)
  end

  def check_owner
    @achievement = Achievement.find(params[:id])
    redirect_to achievements_path if current_user != @achievement.user
  end
end
