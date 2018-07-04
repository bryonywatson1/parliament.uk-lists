class People::AssociationsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_associations.set_url_params({ person_id: params[:person_id] }) },
  }.freeze

  def index
    @person, @seat_incumbencies, @committee_memberships, @government_incumbencies, @opposition_incumbencies = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'SeatIncumbency', 'FormalBodyMembership', 'GovernmentIncumbency', 'OppositionIncumbency')

    @person = @person.first

    @current_party_membership = @person.current_party_membership

    # Only seat incumbencies, not committee roles are being grouped
    incumbencies = GroupingHelper.group(@seat_incumbencies, :constituency, :graph_id)

    roles = []
    roles += incumbencies
    roles += @committee_memberships.to_a
    roles += @government_incumbencies.to_a
    roles += @opposition_incumbencies.to_a

    @sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
      list:             @person.incumbencies,
      parameters:       [:end_date],
      prepend_rejected: false
    })

    @most_recent_incumbency = @sorted_incumbencies.last

    @current_incumbency = @most_recent_incumbency&.current? ? @most_recent_incumbency : nil

    HistoryHelper.reset
    HistoryHelper.add(roles)
    @history = HistoryHelper.history

    @current_roles = @history[:current].reverse!.group_by { |role| Grom::Helper.get_id(role.type) } if @history[:current]

  end
end
