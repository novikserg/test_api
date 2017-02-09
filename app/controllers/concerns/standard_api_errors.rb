module StandardApiErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid,  with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def render_unprocessable_entity_response(exception)
      render json: exception.record.errors, status: :unprocessable_entity
    end

    def render_not_found_response(exception)
      render json: { error: exception.message }, status: :not_found
    end
  end
end
