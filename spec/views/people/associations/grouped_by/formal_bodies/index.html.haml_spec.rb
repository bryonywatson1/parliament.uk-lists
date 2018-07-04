require 'rails_helper'

RSpec.describe 'people/associations/grouped_by/formal_bodies/index', vcr: true do
  constituency_graph_id     = 'MtbjxRrE'
  house_of_commons_graph_id = 'KL2k1BGP'
  house_of_lords_graph_id   = 'm1EgVTLj'

    before do
      assign(:person,
        double(:person,
          display_name:   'Test Display Name',
          full_name:      'Test Full Name',
          statuses:       { house_membership_status: ['Current MP'] },
          graph_id:       '7TX8ySd4',
          current_mp?:    true,
          current_lord?:  false))

      assign(:current_incumbency,
        double(:current_incumbency,
          constituency: double(:constituency, name: 'Aberavon', graph_id: constituency_graph_id, date_range: 'from 2010')))
      assign(:most_recent_incumbency, nil)
      assign(:history, {
      start: double(:start, year: Time.zone.now - 5.years),
      current: [],
      years: {} })
      assign(:seat_incumbencies, count: 2)
      assign(:committee_memberships, [
        double(:committee_membership1,
          type: '/FormalBodyMembership',
          date_range: "from #{(Time.zone.now - 12.months).strftime('%-e %b %Y')} to present",
          formal_body: double(:formal_body,
            name: 'Test Committee Name 1',
            graph_id:   constituency_graph_id,
          )
        ),
        double(:committee_membership2,
          type: '/FormalBodyMembership',
          date_range: "from #{(Time.zone.now - 8.months).strftime('%-e %b %Y')} to present",
          formal_body: double(:formal_body,
            name: 'Test Committee Name 2',
            graph_id:   constituency_graph_id,
          )
        ),
        double(:committee_membership3,
          type: '/FormalBodyMembership',
          date_range: "from #{(Time.zone.now - 9.months).strftime('%-e %b %Y')} to present",
          formal_body: double(:formal_body,
            name: 'Test Committee Name 3',
            graph_id:   constituency_graph_id,
          )
        )
      ])
      assign(:current_party_membership,
        double(:current_party_membership,
          party: double(:party,
            name: 'Conservative',
            graph_id: 'jF43Jxoc')
        )
      )

      render
    end

  context 'header' do
    it 'will render the display name' do
      expect(rendered).to match(/Test Display Name/)
    end
  end

  context '@committee_memberships are present' do
    context 'with roles' do
      let(:history) do
        {
          start: Time.zone.now - 25.years,
          current: [
            double(:seat_incumbency,
              house_of_commons?: true,
              house_of_lords?: false,
              type: '/SeatIncumbency',
              date_range: "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Aberconwy',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:committee_membership,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 3.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:seat_incumbency,
              type: '/SeatIncumbency',
              house_of_commons?: true,
              house_of_lords?: false,
              start_date: Time.zone.now - 2.months,
              end_date:   nil,
              date_range: "from #{(Time.zone.now - 4.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Fake Place 2',
                graph_id:   constituency_graph_id,
              )
            )
          ],
          years: {
            '10': [
              double(:committee_membership,
                type: '/FormalBodyMembership',
                date_range: "from #{(Time.zone.now - 8.years).strftime('%-e %b %Y')} to #{(Time.zone.now - 7.years).strftime('%-e %b %Y')}",
                formal_body: double(:formal_body,
                  name: 'Second Committee Name',
                  graph_id:   constituency_graph_id,
                )
              )
            ]
          }
        }
      end

      before :each do
        assign(:history, history)

        assign(:current_roles, {
          'FormalBodyMembership'.to_s => [
            double(:committee_membership1,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 12.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name 1',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:committee_membership2,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 8.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name 2',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:committee_membership3,
              type: '/FormalBodyMembership',
              date_range: "from #{(Time.zone.now - 9.months).strftime('%-e %b %Y')} to present",
              formal_body: double(:formal_body,
                name: 'Test Committee Name 3',
                graph_id:   constituency_graph_id,
              )
            )
          ]
        })

        render
      end

      context 'showing current' do
        it 'shows header' do
          expect(rendered).to match(/Held currently/)
        end

        context 'Committee roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Committee role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Test Committee Name/)
          end

          it 'will render start date to present' do
            expect(rendered).to match("#{(Time.zone.now - 3.months).strftime('%-e %b %Y')} to present")
          end
        end
      end

      context 'showing historic' do
        it 'shows header' do
          expect(rendered).to match(/Held in the last 10 years/)
        end

        context 'Committee roles' do
          it 'will render the correct sub-header' do
            expect(rendered).to match(/Committee role/)
          end

          it 'will render the correct title' do
            expect(rendered).to match(/Second Committee Name/)
          end

          it 'will render start date to present' do
            expect(rendered).to match((Time.zone.now - 8.years).strftime('%-e %b %Y'))
          end

          it 'will render present status' do
            expect(rendered).to match((Time.zone.now - 7.years).strftime('%-e %b %Y'))
          end
        end
      end

      context 'showing start date' do
        it 'shows start date' do
          expect(rendered).to match((Time.zone.now - 25.years).strftime('%Y'))
        end
      end
    end
  end

  context '@committee_memberships are not present' do
    context 'with roles' do
      let(:history) do
        {
          start: Time.zone.now - 25.years,
          current: [
            double(:seat_incumbency,
              house_of_commons?: true,
              house_of_lords?: false,
              type: '/SeatIncumbency',
              date_range: "from #{(Time.zone.now - 2.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Aberconwy',
                graph_id:   constituency_graph_id,
              )
            ),
            double(:seat_incumbency,
              type: '/SeatIncumbency',
              house_of_commons?: true,
              house_of_lords?: false,
              start_date: Time.zone.now - 2.months,
              end_date:   nil,
              date_range: "from #{(Time.zone.now - 4.months).strftime('%-e %b %Y')} to present",
              constituency: double(:constituency,
                name:       'Fake Place 2',
                graph_id:   constituency_graph_id,
              )
            )
          ],
          years: {
            '10': [
              double(:seat_incumbency,
                type: '/SeatIncumbency',
                house_of_commons?: true,
                house_of_lords?: false,
                start_date: Time.zone.now - 2.months,
                end_date:   nil,
                date_range: "from #{(Time.zone.now - 4.months).strftime('%-e %b %Y')} to #{(Time.zone.now - 7.years).strftime('%-e %b %Y')}",
                constituency: double(:constituency,
                  name:       'Fake Place 2',
                  graph_id:   constituency_graph_id,
                )
              )
            ]
          }
        }
      end

      before :each do
        assign(:history, history)
        assign(:committee_memberships, [])
        render
      end

      it 'shows no committee memberships message' do
        expect(rendered).to match(/No Committee Memberships/)
      end
    end
  end
end
