require 'rails_helper'

RSpec.describe 'parliaments/members/index', vcr: true do
  before do
    assign(:people, [])
    assign(:parliament, double(:parliament, date_range: '2005 to 2010', graph_id: 'd7b0ec7n'))
    assign(:letters, [])
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/MPs and Lords/)
    end

    it 'will render the correct date range' do
      expect(rendered).to match(/2005 to 2010 Parliament/)
    end

    it 'will render the correct letters' do
      expect(rendered).to match(/A to Z - showing all/)
    end

    it 'will render pugin/components/_navigation-letter partial' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

  end

  context '@people' do
    it 'will render pugin/elements/_list partial' do
      expect(response).to render_template(partial: 'pugin/elements/_list')
    end
  end

end
