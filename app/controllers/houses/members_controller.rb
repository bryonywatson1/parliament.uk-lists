module Houses
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_members.set_url_params({ house_id: params[:house_id] }) },
      a_to_z_current:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_members_a_to_z.set_url_params({ house_id: params[:house_id] }) },
      current:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_members.set_url_params({ house_id: params[:house_id] }) },
      letters:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_members_by_initial.set_url_params({ house_id: params[:house_id], initial: params[:letter] }) },
      current_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_members_by_initial.set_url_params({ house_id: params[:house_id], initial: params[:letter] }) },
      a_to_z:          proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_members_a_to_z.set_url_params({ house_id: params[:house_id] }) }
    }.freeze

    def index
      @house, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'Person', ::Grom::Node::BLANK)
      @house = @house.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)
      @current_house_id, @other_house_id = Parliament::Utils::Helpers::HousesHelper.house_id_string(@house)
    end

    def current
      @house, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'Person', ::Grom::Node::BLANK)
      @house = @house.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)
      @current_house_id, @other_house_id = Parliament::Utils::Helpers::HousesHelper.house_id_string(@house)
    end

    def letters
      @house, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'Person', ::Grom::Node::BLANK)
      @house = @house.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)
      @current_house_id, @other_house_id = Parliament::Utils::Helpers::HousesHelper.house_id_string(@house)
      @all_path = :house_members_path
    end

    def current_letters
      @house, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'Person', ::Grom::Node::BLANK)
      @house = @house.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)
      @current_house_id, @other_house_id = Parliament::Utils::Helpers::HousesHelper.house_id_string(@house)
      @all_path = :house_members_current_path
    end

    def a_to_z
      @house, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', ::Grom::Node::BLANK)
      @house = @house.first
      @house_id = params[:house_id]
      @letters = @letters.map(&:value)
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)
      @all_path = :house_members_path
    end

    def a_to_z_current
      @house, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', ::Grom::Node::BLANK)
      @house = @house.first
      @house_id = params[:house_id]
      @letters = @letters.map(&:value)
      @current_person_type, @other_person_type = Parliament::Utils::Helpers::HousesHelper.person_type_string(@house)
      @all_path = :house_members_current_path
    end
  end
end
