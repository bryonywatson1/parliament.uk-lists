class PeopleController < ApplicationController
  before_action :data_check, :build_request, except: :postcode_lookup

  ROUTE_MAP = {
    index:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_index },
    letters:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_by_initial.set_url_params({ initial: params[:letter] }) },
    a_to_z:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_a_to_z },
    lookup_by_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.person_by_substring.set_url_params({ substring: params[:letters] }) }
  }.freeze

  def index
    @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :sort_name, 'Person', ::Grom::Node::BLANK)
  end

  def postcode_lookup
    flash[:postcode] = params[:postcode]
    redirect_to person_path(params[:person_id])
  end

  def letters
    @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :sort_name, 'Person', ::Grom::Node::BLANK)
    @all_path = :people_path
  end

  def a_to_z
    @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
    @all_path = :people_path
  end

  def lookup_by_letters
    @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Person', ::Grom::Node::BLANK)
    return redirect_to person_path(@people.first.graph_id) if @people.size == 1
    @people = @people.sort_by(:name)
    @letters = @letters.map(&:value)
  end
end
