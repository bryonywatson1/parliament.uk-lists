module Parties
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_members.set_url_params({ party_id: params[:party_id] }) },
      current:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_current_members.set_url_params({ party_id: params[:party_id] }) },
      letters:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_members_by_initial.set_url_params({ party_id: params[:party_id], initial: params[:letter] }) },
      current_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_current_members_by_initial.set_url_params({ party_id: params[:party_id], initial: params[:letter] }) },
      a_to_z:          proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_members_a_to_z.set_url_params({ party_id: params[:party_id] }) },
      a_to_z_current:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_current_members_a_to_z.set_url_params({ party_id: params[:party_id] }) }
    }.freeze

    def index
      @party, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', 'Person', ::Grom::Node::BLANK)
      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current
      @party, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', 'Person', ::Grom::Node::BLANK)
      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def letters
      @party, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', 'Person', ::Grom::Node::BLANK)
      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
      @all_path = :party_members_path
    end

    def current_letters
      @party, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', 'Person', ::Grom::Node::BLANK)
      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
      @all_path = :party_members_current_path
    end

    def a_to_z
      @party, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', ::Grom::Node::BLANK)
      @party = @party.first
      @party_id = params[:party_id]
      @letters = @letters.map(&:value)
      @all_path = :party_members_path
    end

    def a_to_z_current
      @party, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Party', ::Grom::Node::BLANK)
      @party = @party.first
      @party_id = params[:party_id]
      @letters = @letters.map(&:value)
      @all_path = :party_members_current_path
    end
  end
end
