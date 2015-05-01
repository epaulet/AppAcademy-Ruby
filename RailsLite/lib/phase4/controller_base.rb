require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    # after creating response, store the session in the response
    def redirect_to(url)
      super
      session.store_session(res)
    end

    # after creating response, store the session in the response
    def render_content(content, content_type)
      super
      session.store_session(res)
    end

    # method exposing a `Session` object
    def session
      @session || @session = Session.new(@req)
    end
  end
end
