class TestsController < Simpler::Controller
  def index
    @time = Time.now
  end

  def show
    render plain: "Show test with id: #{params[:id]}"
  end

  def create; end
end
