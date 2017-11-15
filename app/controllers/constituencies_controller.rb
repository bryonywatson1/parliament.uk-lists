class ConstituenciesController < ApplicationController
  before_action :data_check, :build_request, except: :postcode_lookup

  ROUTE_MAP = {
    index:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_index },
    current:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_current },
    letters:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_by_initial.set_url_params({ initial: params[:letter] }) },
    current_letters:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_current_by_initial.set_url_params({ initial: params[:letter] }) },
    a_to_z:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_a_to_z },
    a_to_z_current:    proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_current_a_to_z },
    lookup_by_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.constituency_by_substring.set_url_params({ substring: params[:letters] }) }
  }.freeze

  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'https://id.parliament.uk/schema/ConstituencyGroup'.
  def index
    @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ConstituencyGroup', ::Grom::Node::BLANK)
    @constituencies = @constituencies.multi_direction_sort({name: :asc, start_date: :desc})
    @letters = @letters.map(&:value)
  end

  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'https://id.parliament.uk/schema/ConstituencyGroup'.
  def current
    @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :name, 'ConstituencyGroup', ::Grom::Node::BLANK)
  end

  # Renders a list of constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'https://id.parliament.uk/schema/ConstituencyGroup'.
  def letters
    @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ConstituencyGroup', ::Grom::Node::BLANK)
    @constituencies = @constituencies.multi_direction_sort({name: :asc, start_date: :desc})
    @letters = @letters.map(&:value)
    @all_path = :constituencies_path
  end

  # Renders a list of current constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'https://id.parliament.uk/schema/ConstituencyGroup'.
  def current_letters
    @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :name, 'ConstituencyGroup', ::Grom::Node::BLANK)
    @all_path = :constituencies_current_path
  end

  # Renders a list of letters taken from first letter of all constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all constituencies.
  def a_to_z
    @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
    @all_path = :constituencies_path
  end

  # Renders a list of letters taken from first letter of all current constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all current constituencies.
  def a_to_z_current
    @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
    @all_path = :constituencies_current_path
  end

  # Look up to find a constituency given a string.  Redirects to either a single constituency or list of constituencies.
  # @controller_action_param :letters [String] case insensitive string to lookup.
  def lookup_by_letters
    @constituencies, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ConstituencyGroup', ::Grom::Node::BLANK)
    if @constituencies.size == 1
      redirect_to constituency_path(@constituencies.first.graph_id)
      return
    end
    @constituencies = @constituencies.multi_direction_sort({name: :asc, start_date: :desc})
    @letters = @letters.map(&:value)
  end
end
