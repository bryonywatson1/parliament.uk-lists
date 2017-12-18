require 'rails_helper'

RSpec.describe 'parties/members/letters', vcr: true do
  before do
    assign(:people, [])
    assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))
    assign(:letters, 'A')
    assign(:all_path, :house_parties_party_members_path)
    allow(view).to receive(:house_parties_party_members_path).and_return('/houses/Kz7ncmrt/parties/AJgeHzL2/members')
    allow(view).to receive(:house_parties_party_members_a_z_letter_path).and_return('/houses/Kz7ncmrt/parties/AJgeHzL2/members/a-z/a')

    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Conservative - Current and former MPs and Lords/)
    end

    it 'will render the correct sub-header' do
      expect(rendered).to match(/A to Z - showing results for A/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render pugin/elements/_list' do
      expect(response).to render_template('pugin/elements/_list')
    end
  end
end
