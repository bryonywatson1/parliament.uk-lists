module Houses
  class CommitteesController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_committees_index.set_url_params({ house_id: params[:house_id] })},
      a_to_z:          proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_committees_a_to_z.set_url_params({ house_id: params[:house_id] }) },
      letters:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_committees_by_initial.set_url_params({ house_id: params[:house_id], initial: params[:letter] }) },
      current:         proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_committees.set_url_params({ house_id: params[:house_id] }) },
      current_letters: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_committees_by_initial.set_url_params({ house_id: params[:house_id], initial: params[:letter] }) },
      a_to_z_current:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.house_current_committees_a_to_z.set_url_params({ house_id: params[:house_id] }) }
    }.freeze

    def index
      @house, @committees, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'FormalBody', ::Grom::Node::BLANK)
      @house      = @house.first
      @committees = @committees.sort_by(:name)
      @letters    = @letters.map(&:value)
    end

    def a_to_z
      @house, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', ::Grom::Node::BLANK)
      @house = @house.first
      @letters = @letters.map(&:value)
      @all_path = :house_committees_path
    end

    def letters
      @house, @committees, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'FormalBody', ::Grom::Node::BLANK)
      @house      = @house.first
      @committees = @committees.sort_by(:name)
      @letters    = @letters.map(&:value)
      @all_path   = :house_committees_path
    end

    def current
      @house, @committees, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'FormalBody', ::Grom::Node::BLANK)
      @house      = @house.first
      @committees = @committees.sort_by(:name)
      @letters    = @letters.map(&:value)
    end

    def a_to_z_current
      @house, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', ::Grom::Node::BLANK)
      @house = @house.first
      @letters = @letters.map(&:value)
      @all_path = :house_committees_current_path
    end

    def current_letters
      @house, @committees, @letters = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'House', 'FormalBody', ::Grom::Node::BLANK)
      @house      = @house.first
      @committees = @committees.sort_by(:name)
      @letters    = @letters.map(&:value)
      @all_path   = :house_committees_current_path
    end
  end
end
