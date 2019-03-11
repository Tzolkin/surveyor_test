module SurveyorControllerCustomMethods
  def self.included(base)
    base.send :before_action, :require_user
    base.send :layout, 'surveyor_custom'
    # base.send :before_action, :login_required  # Restful Authentication
  end

  # Actions
  def new
    super
    # @title = "You can take these surveys"
  end
  def create
    super
  end
  def show
    super
  end
  def edit
    # @response_set is set in before_action - set_response_set_and_render_context
    if @response_set
      @sections = SurveySection.where(survey_id: @response_set.survey_id).includes([:survey, { questions: [{ answers: :question }, { question_group: :dependency }, :dependency] }])
      @section = (section_id_from(params) ? @sections.where(id: section_id_from(params)).first : @sections.first) || @sections.first
      @survey = @section.survey
      set_dependents
    else
      flash[:notice] = t('surveyor.unable_to_find_your_responses')
      redirect_to surveyor_index
    end
  end

  def update
    if params[:r]
      question_ids_for_dependencies = (params[:r].to_unsafe_h || []).map { |_k, v| v['question_id'] }.compact.uniq
    end
    saved = load_and_update_response_set_with_retries

    return redirect_with_message(surveyor_finish, :notice, t('surveyor.completed_survey')) if saved && params[:finish]

    respond_to do |format|
      format.html do
        if @response_set.nil?
          return redirect_with_message(surveyor.available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses'))
        else
          flash[:notice] = t('surveyor.unable_to_update_survey') unless saved
          redirect_to surveyor.edit_my_survey_path(anchor: anchor_from(params[:section]), section: section_id_from(params))
        end
      end
      format.js do
        if @response_set
          render json: @response_set.reload.all_dependencies(question_ids_for_dependencies)
        else
          render text: "No response set #{params[:response_set_code]}", status: 404
        end
      end
    end
  end

  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    super # surveyor.available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    super # surveyor.available_surveys_path
  end
end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
