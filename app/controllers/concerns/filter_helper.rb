module FilterHelper

  def self.filter_sort(request, types, sort_type)
    thing, letters = self.filter_letters(request, types)
    thing = thing.sort_by(sort_type)
    letters = letters.map(&:value)
    return thing, letters
  end


  def self.filter(request, *types)
    types_to_filter = self.filter_types(*types)
    Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      request, *types_to_filter
    )
  end

  def self.filter_letters(request, *types)
    types_to_filter = self.filter_types(*types)
    Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      request, *types_to_filter,
      ::Grom::Node::BLANK
    )
  end

  def self.filter_types(*types)
    types_to_filter = []
    types.each do |type|
      type == 'ordnance' ? types_to_filter << 'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion' : types_to_filter << Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type)
    end
    types_to_filter
  end

end
