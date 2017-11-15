module People
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_index },
      current:         proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_current },
      letters:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_by_initial.set_url_params({ initial: params[:letter] }) },
      current_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_current_by_initial.set_url_params({ initial: params[:letter] }) },
      a_to_z:          proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_a_to_z },
      a_to_z_current:  proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.member_current_a_to_z }
    }.freeze

    def index
      @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :sort_name, 'Person', ::Grom::Node::BLANK)
    end

    def current
      @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :sort_name, 'Person', ::Grom::Node::BLANK)
    end

    def letters
      @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :sort_name, 'Person', ::Grom::Node::BLANK)
      @all_path = :people_members_path
    end

    def current_letters
      @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter_sort(@request, :sort_name, 'Person', ::Grom::Node::BLANK)
      @all_path = :people_members_current_path
    end

    def a_to_z
      @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
      @all_path = :people_members_path
    end

    def a_to_z_current
      @letters = Parliament::Utils::Helpers::RequestHelper.process_available_letters(@request)
      @all_path = :people_members_current_path
    end
  end
end
