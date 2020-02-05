class ApplicationController < ActionController::Base
  around_action :logging_traffic

  def logging_traffic
    logger.info "USERAGENT: #{request.headers['HTTP_USER_AGENT']}"
    begin
      yield
    ensure
      logger.info "response_status: #{response.status}"
    end
  end
end
