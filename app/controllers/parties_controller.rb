class PartiesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_index },
    current:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_current },
    letters:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_by_initial.set_url_params({ initial: params[:letter] }) },
    a_to_z:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_a_to_z },
    lookup_by_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_by_substring.set_url_params({ substring: params[:letters] }) },

    # NOT IN THE ORIGINAL ROUTE MAP BUT IN NEW DATA API URL STRUCTURE??
    current_a_to_z:      proc { ParliamentHelper.parliament_request.party_current_a_to_z }
  }.freeze

  def index
    @parties, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :name, 'Party', ::Grom::Node::BLANK)
  end

  def current
    @parties = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party').sort_by(:name)
  end

  def letters
    @parties, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :name, 'Party', ::Grom::Node::BLANK)
    @all_path = :parties_path
  end

  def a_to_z
    @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z].call)
    @all_path = :parties_path
  end

  def lookup_by_letters
    @parties, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', ::Grom::Node::BLANK)
    return redirect_to party_path(@parties.first.graph_id) if @parties.size == 1
    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end
end
