class AssociationsController < ApplicationController
    def index
    end

    def new
        @association = Association.new
    end

    def show
        @association = Association.find_by(id: params[:id])
    end

    def create
        association = Association.new(association_params)
        if association.save
            flash[:notice] = "診断が完了しました"
            redirect_to association_path(association.id)
        else
            redirect_to :action => "new"
        end
    end
  
  private
    def association_params
        params.require(:association).permit(:question1, :question2, :question3, :question4)
    end

end
