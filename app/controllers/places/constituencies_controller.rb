module Places
  class ConstituenciesController < ApplicationController
    before_action :data_check, :build_request

    # Data API endpoints currently refer to Regions, as the queries we are running use ONS data related specifically to regions
    # TODO: Potentially repurpose controller and data API endpoints if places other than regions come into scope
    ROUTE_MAP = {
      index:      proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.region_constituencies.set_url_params(region_code: params[:place_id]) },
      a_to_z:     proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.region_constituencies_a_to_z.set_url_params(region_code: params[:place_id]) },
      letters:    proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.region_constituencies_by_initial.set_url_params(region_code: params[:place_id], initial: params[:letter]) },
    }.freeze

    # Renders a list of all constituencies in a given place with current incumbents.
    # @return [Array] Array of Grom::Nodes of type 'EuropeanRegion'
    # @return [Array] Array of Grom::Nodes of type 'ConstituencyGroup'
    # @return [Array] Array of blank Grom::Nodes, from which to find letters
    def index
      @place, @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ordnance', 'ConstituencyGroup', ::Grom::Node::BLANK)
      @place = @place.first
      @constituencies = @constituencies.sort_by(:name)
      @letters = @letters.map(&:value)
    end

    # Renders a list of letters taken from first letter of all constituencies within a given place.
    # Shown with an a - z partial view.
    def a_to_z
      @place, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ordnance', ::Grom::Node::BLANK)
      @place = @place.first
      @letters = @letters.map(&:value)
    end

    # Renders a list of constituencies in a given place that begin with a particular letter given the letter. Shown with an a - z partial view.
    # @controller_action_param :letter [String] single letter that is case insensitive.
    def letters
      @place, @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ordnance', 'ConstituencyGroup', ::Grom::Node::BLANK)
      @place = @place.first
      @constituencies = @constituencies.sort_by(:name)
      @letters = @letters.map(&:value)
    end
  end
end
