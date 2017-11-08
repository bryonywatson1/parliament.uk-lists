module FilterHelper

  def self.letters(request, types, sort_type)
    thing, letters = self.filter_letters(request, types)
    thing = thing.sort_by(sort_type)
    letters = letters.map(&:value)
    return thing, letters
  end


  def self.multi_filter(request, type1, type2)
    Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type1),
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type2)
    )
  end

  def self.filter_letters(request, *types)
    types_to_filter = []
    types.each do |type|
      types_to_filter << Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type)
    end
    Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      request, *types_to_filter,
      ::Grom::Node::BLANK
    )
  end

end
