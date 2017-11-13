module Constituencies
  class ContactPointsController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_contact_point.set_url_params({ constituency_id: params[:constituency_id] }) }
    }.freeze

    # Renders a contact point given a constituency id.
    # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
    # @return [Grom::Node] object with type 'https://id.parliament.uk/schema/ConstituencyGroup' which has a contact point.
    def index
      @constituency = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ConstituencyGroup').first
    end
  end
end
