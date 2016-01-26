class VisitorsController < ApplicationController
  def index
    @schools = School.all
    if params[:search]
      s = "%#{params[:search]}%"
      i = "%#{params[:instituciones]}%"
      if params[:search].to_i.is_a?(Integer)  && params[:search].to_i > 0 && !i.present?
        @students = Student.where(identification: params[:search].to_i)
      elsif params[:search].to_i.is_a?(Integer)  && params[:search].to_i > 0 && i.present?
        @students = Student.joins(:schools).where(identification: params[:search].to_i)
      else
        @students = Student.where("lower(name) LIKE :search", search: s.downcase)
      end
    else
      @students = Student.all.order(:name).limit 200
    end
  end
end
