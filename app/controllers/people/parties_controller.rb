module People
  class PartiesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_parties.set_url_params({ person_id: params[:person_id] }) },
      current: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_current_party.set_url_params({ person_id: params[:person_id] }) }
    }.freeze

    def index
      @person, @party_memberships = FilterHelper.multi_filter(@request, 'Person', 'PartyMembership')
      @person = @person.first
      @party_memberships = @party_memberships.reverse_sort_by(:start_date)
    end

    def current
      @person, @party = FilterHelper.multi_filter(@request, 'Person', 'Party')
      @person = @person.first
      @party = @party.first
    end
  end
end
