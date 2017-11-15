module Parliaments
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:    proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_members.set_url_params({ parliament_id: params[:parliament_id] }) },
      a_to_z:   proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_members.set_url_params({ parliament_id: params[:parliament_id] }) },
      letters:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parliament_members_by_initial.set_url_params({ parliament_id: params[:parliament_id], initial: params[:letter] }) }

      # Currently, a_to_z renders the same data as index, so this is reflected in the api request
      # But a route does exist for it in the Data API
      # a_to_z:  proc { |params| ParliamentHelper.parliament_request.parliament_members_a_to_z.set_url_params({ parliament_id: params[:parliament_id] }) },
    }.freeze

    def index
      @parliament, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', 'Person', ::Grom::Node::BLANK)
      @parliament = @parliament.first
      @people     = @people.sort_by(:sort_name)
      @letters    = @letters.map(&:value)
    end

    def letters
      @parliament, @people, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', 'Person', ::Grom::Node::BLANK)
      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
      @people     = @people.sort_by(:sort_name)
      @all_path = :parliament_members_path
    end

    def a_to_z
      @parliament, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ParliamentPeriod', ::Grom::Node::BLANK)
      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
      @all_path = :parliament_members_path
    end
  end
end
