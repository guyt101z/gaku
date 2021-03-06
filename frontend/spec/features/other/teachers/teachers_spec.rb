require 'spec_helper'

describe 'Teachers' do

  let(:teacher) { create(:teacher, name: 'John', surname: 'Doe') }
  let(:teacher2) { create(:teacher) }

  before(:all) { set_resource 'teacher' }
  before { as :admin }

  context 'new', js: true do
    before do
      visit gaku.teachers_path
      click new_link
    end

    it 'creates and shows' do
      expect do
        fill_in 'teacher_name', with: 'John'
        fill_in 'teacher_surname', with: 'Doe'
        click_button 'submit-teacher-button'
        flash_created?
      end.to change(Gaku::Teacher, :count).by 1

      has_content? 'John'
      count? 'Teachers list(1)'
    end

    it { has_validations? }
  end

  context 'existing', js: true do
    before do
      teacher
      visit gaku.teachers_path
    end

    context 'edit' do
      before { visit gaku.edit_teacher_path(teacher) }

      it 'edits' do
        fill_in 'teacher_surname', with: 'Kostova'
        fill_in 'teacher_name',    with: 'Marta'
        click submit

        flash_updated?

        has_content? 'Kostova'
        has_content? 'Marta'
        has_no_content? 'John'
        has_no_content? 'Doe'

        teacher.reload
        expect(teacher.name).to eq 'Marta'
        expect(teacher.surname).to eq 'Kostova'
      end

      it 'has validations' do
        fill_in 'teacher_surname', with: ''
        has_validations?
      end
    end

    it 'deletes' do
      visit gaku.edit_teacher_path(teacher2)

      expect do
        click modal_delete_link
        within(modal) { click_on 'Delete' }
        accept_alert
        flash_destroyed?
      end.to change(Gaku::Teacher, :count).by(-1)

      page.should_not have_content "#{teacher2.name}"
      within(count_div) { page.should_not have_content 'Teachers list(#{teacher_count - 1})' }
      current_path.should eq gaku.teachers_path
    end

  end

end
