module BetterResponder
  class Responder

    def initialize(context)
      @context = context
    end

    def run(condition, success_render, fail_render = nil)
      provide_response condition ? [success_render, :success] : [fail_render || success_render, :fail]
    end

    private

    def provide_response(params)
      render_params = params.first
      render_type = params[1]
      method = render_params.keys.first
      @context.send method, render_params[method], :"#{flash_type(render_type)}" => I18n.t(message_builder(render_type))
    end

    def message_builder(type)
      "responder.#{controller_name}.#{action_name}.#{type}"
    end

    def action_name
      @context.params[:action]
    end

    def controller_name
      @context.class.name.underscore.split("_").first
    end

    def flash_type(render_type)
      h = {success: :notice, fail: :alert}
      h[render_type.to_sym]
    end

  end
end