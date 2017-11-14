class ParliamentsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:               proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_index },
  }.freeze

  def index
    @parliaments = @request.get.reverse_sort_by(:number)
  end
end
