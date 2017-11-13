module FilterHelper

  def self.filter_sort(request, types, sort_type)
    thing, letters = self.filter_letters(request, types)
    thing = thing.sort_by(sort_type)
    letters = letters.map(&:value)
    return thing, letters
  end


  def self.filter(request, *types)
    types_to_filter = []
    types.each do |type|
      if type == 'ordnance'
        types_to_filter << 'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion'
      else
      types_to_filter << Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type)
      end
    end
    Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      request, *types_to_filter)
  end

  def self.filter_letters(request, *types)
    types_to_filter = []
    types.each do |type|
      if type == 'ordnance'
        types_to_filter << 'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion'
      else
      types_to_filter << Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path(type)
      end
    end
    Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      request, *types_to_filter,
      ::Grom::Node::BLANK
    )
  end

end
