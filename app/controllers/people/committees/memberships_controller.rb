module People
  module Committees
    class MembershipsController < ApplicationController
      before_action :data_check, :build_request

      ROUTE_MAP = {
        index:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_committees_memberships_index.set_url_params({ person_id: params[:person_id] }) },
        current: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_current_committees_memberships.set_url_params({ person_id: params[:person_id] }) }
      }.freeze

      def index
        @person, @committee_memberships, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'FormalBodyMembership', ::Grom::Node::BLANK)
        @person                = @person.first
        @committee_memberships = @committee_memberships.reverse_sort_by(:start_date)
        @letters               = @letters.map(&:value)
      end

      def current
        @person, @committee_memberships, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', 'FormalBodyMembership', ::Grom::Node::BLANK)
        @person                = @person.first
        @committee_memberships = @committee_memberships.reverse_sort_by(:start_date)
        @letters               = @letters.map(&:value)
      end
    end
  end
end
