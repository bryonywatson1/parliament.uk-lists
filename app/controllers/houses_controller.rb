class HousesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:              proc  { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_index },
    lookup_by_letters:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_by_substring.set_url_params({ substring: params[:letters] }) }
  }.freeze

  def index
    @houses = @request.get.sort_by(:name)
  end

  def lookup_by_letters
    data = @request.get
    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end
end
