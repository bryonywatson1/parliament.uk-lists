module People
  class ConstituenciesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_constituencies.set_url_params({ person_id: params[:person_id] }) },
      current: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_current_constituency.set_url_params({ person_id: params[:person_id] }) }
    }.freeze

    def index
      @person, @seat_incumbencies = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'SeatIncumbency')
      @person = @person.first
      @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
    end

    def current
      @person, @constituency = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'ConstituencyGroup')
      @person = @person.first
      @constituency = @constituency.first
    end
  end
end
