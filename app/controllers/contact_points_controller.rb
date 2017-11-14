class ContactPointsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index: proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.contact_point_index },
  }.freeze

  def index
    @contact_points = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'ContactPoint')
  end
end
