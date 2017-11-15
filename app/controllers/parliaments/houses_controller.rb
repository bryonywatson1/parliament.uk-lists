module Parliaments
  class HousesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_houses.set_url_params({ parliament_id: params[:parliament_id] }) },
    }.freeze

    def index
      @parliament, @houses = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', 'House')
      @parliament = @parliament.first
      @houses     = @houses.sort_by(:name)
    end

  end
end
