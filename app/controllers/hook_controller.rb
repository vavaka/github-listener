class HookController < ApplicationController
  def create
    if params[:payload]
      hook = Hook.new(params[:payload])
      hook.fetch_affected_i18n_files
    end
  rescue => e
      logger.info "error: #{e.message}"
  ensure
    render :nothing => true
  end
end
