module People
  class CommitteesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_committees_index.set_url_params({ person_id: params[:person_id] }) },
    }.freeze

    def index
      @person, @committee_memberships = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'FormalBodyMembership')
      @person = @person.first
      @committee_memberships = @committee_memberships.reverse_sort_by(:start_date)
    end
  end
end
