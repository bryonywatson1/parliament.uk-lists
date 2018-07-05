require 'rails_helper'

RSpec.describe 'people/associations/grouped_by/opposition/index', vcr: true do
  constituency_graph_id     = 'MtbjxRrE'
  house_of_commons_graph_id = 'KL2k1BGP'
  house_of_lords_graph_id   = 'm1EgVTLj'
  opposition_graph_id       = ''

  before do
    assign(:person,
      double(:person,
        display_name:   'Test Display Name',
        full_name:      'Test Full Name',
        statuses:       { house_membership_status: ['Current MP'] },
        graph_id:       '7TX8ySd4',
        image_id:       'CCCCCCCC',
        current_mp?:    true,
        current_lord?:  false))

    assign(:image,
        double(:image,
          graph_id:     'XXXXXXXX'))

    assign(:current_incumbency,
      double(:current_incumbency,
        constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
    assign(:most_recent_incumbency, nil)
    assign(:history, {
    start: double(:start, year: Time.zone.now - 5.years),
    current: [],
    years: {} })
    assign(:current_party_membership,
      double(:current_party_membership,
        party: double(:party,
          name: 'Conservative',
          graph_id: 'jF43Jxoc')
      )
    )
    assign(:seat_incumbencies, count: 2)
    assign(:opposition_incumbencies, [
      double(:opposition_incumbency,
             type: '/oppositionIncumbency',
             date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
             opposition_position: double(:opposition_position,
                                 name: 'Test opposition Position Name',
                                 graph_id:   opposition_graph_id,
        )
      ),
      double(:opposition_incumbency,
             type: '/OppositionIncumbency',
             date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
             opposition_position: double(:opposition_position,
                                 name: 'Opposition Role 1',
                                 graph_id:   opposition_graph_id,
        )
      )
    ])
    assign(:sorted_incumbencies, [
      double(:first_incumbency,
        start_date: Time.zone.now - 5.years
      )
    ])

    render
  end

  context 'header' do
    it 'will render the display name' do
      expect(rendered).to match(/Test Display Name/)
    end
  end

  context '@opposition_incumbencies are present' do
    context 'with roles' do
      let(:history) do
        {
          start: Time.zone.now - 25.years,
          current: [
            double(:opposition_incumbency,
                   type: '/oppositionIncumbency',
                   date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
                   opposition_position: double(:opposition_position,
                                       name: 'Test opposition Position Name',
                                       graph_id:   opposition_graph_id,
              )
            ),
            double(:opposition_incumbency,
                   type: '/OppositionIncumbency',
                   date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
                   opposition_position: double(:opposition_position,
                                       name: 'Opposition Role 1',
                                       graph_id:   opposition_graph_id,
              )
            )
          ],
          years: {
            '10': [
              double(:opposition_incumbency,
                 type: '/OppositionIncumbency',
                 date_range: "from #{(Time.zone.now - 5.years).strftime('%-e %b %Y')} to #{(Time.zone.now - 3.years).strftime('%-e %b %Y')}",
                 opposition_position: double(:opposition_position,
                   name: 'Opposition Role 2',
                   graph_id:   opposition_graph_id,
                 )
              )
            ]
          }
        }
      end

      before :each do
        assign(:history, history)

        assign(:current_roles, {
          'OppositionIncumbency'.to_s => [
            double(:opposition_incumbency,
              type: '/OppositionIncumbency',
              date_range: "from #{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present",
              opposition_position: double(:opposition_position,
                name: 'Opposition Role 1',
                graph_id:   opposition_graph_id,
              )
            )
          ]
        })

        render
      end

      context 'showing current' do
        context 'Opposition roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Opposition role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Opposition Role 1/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 5.months).strftime('%-e %b %Y')} to present")
          end
        end
      end

      context 'showing historic' do
        it 'shows header' do
          expect(rendered).to match(/Held in the last 10 years/)
        end

        context 'Opposition roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Opposition Role 2/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Opposition Role 2/)
          end

          it 'will render start date to present' do
            expect(rendered).to match((Time.zone.now - 5.years).strftime('%-e %b %Y'))
          end

          it 'will render present status' do
            expect(rendered).to match((Time.zone.now - 3.years).strftime('%-e %b %Y'))
          end
        end
      end

      context 'showing start date' do
        it 'shows start date' do
          expect(rendered).to match((Time.zone.now - 5.years).strftime('%Y'))
        end
      end
    end
  end

  context '@opposition_incumbencies are not present' do
    context 'with roles' do
      let(:history) {}

      before :each do
        assign(:history, history)
        assign(:opposition_incumbencies, [])
        render
      end

      it 'shows no committee memberships message' do
        expect(rendered).to match(/No Opposition Roles/)
      end
    end
  end
end
