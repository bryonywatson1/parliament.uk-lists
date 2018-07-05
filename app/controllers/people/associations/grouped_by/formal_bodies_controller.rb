module People
  module Associations
    module GroupedBy
      class FormalBodiesController < ApplicationController
        before_action :data_check, :build_request

        ROUTE_MAP = {
          index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_associations_grouped_by_formal_bodies.set_url_params({ person_id: params[:person_id] }) },
        }.freeze

        def index
          @person, @seat_incumbencies, @committee_memberships = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'SeatIncumbency', 'FormalBodyMembership')

          @person = @person.first

          @current_party_membership = @person.current_party_membership

          # Only seat incumbencies, not committee roles are being grouped
          incumbencies = GroupingHelper.group(@seat_incumbencies, :constituency, :graph_id)

          roles = []
          roles += @committee_memberships.to_a

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

        end
      end
    end
  end
end
