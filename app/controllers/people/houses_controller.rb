module People
  class HousesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_houses.set_url_params({ person_id: params[:person_id] }) },
      current: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_current_house.set_url_params({ person_id: params[:person_id] }) }
    }.freeze

    def index
      @person, @incumbencies = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'ParliamentaryIncumbency')
      @person = @person.first
      @incumbencies = @incumbencies.reverse_sort_by(:start_date)
    end

    def current
      @person, @house = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'House')
      @person = @person.first
      @house = @house.first
    end
  end
end
