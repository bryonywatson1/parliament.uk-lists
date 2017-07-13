class ParliamentsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:               proc { ParliamentHelper.parliament_request.parliaments }
  }.freeze

  def index
    @parliaments = @request.get.reverse_sort_by(:number)
  end

end