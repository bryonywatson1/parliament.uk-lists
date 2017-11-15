module Parliaments
  module Houses
    class PartiesController < ApplicationController
      before_action :data_check, :build_request

      ROUTE_MAP = {
        index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_house_parties.set_url_params({ parliament_id: params[:parliament_id], house_id: params[:house_id] }) },
      }.freeze

      def index
        @parliament, @house, @parties, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', 'House', 'Party', ::Grom::Node::BLANK)
        @parliament = @parliament.first
        @house      = @house.first
        @parties    = @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
        @letters    = @letters.map(&:values)
      end
    end
  end
end
