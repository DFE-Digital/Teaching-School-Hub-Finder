class MonitoringController < ActionController::Base
  def healthcheck
    respond_to do |format|
      format.json do
        render json: { status: "OK", git_commit_sha: ENV["GIT_COMMIT_SHA"] }
      end
    end
  end
end
