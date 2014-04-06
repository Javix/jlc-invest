require 'spec_helper'

describe "Admin Pages" do
  subject { page }

  describe "index" do

    let(:admin) { create(:admin) }

    before(:each) do
      sign_in admin
      visit admins_path
    end

    it { should have_title(full_title(I18n.t(:list_all, model: Admin.model_name.human.pluralize))) }
    it { should have_selector('h1', text: I18n.t(:list_all, model: Admin.model_name.human.pluralize)) }

    before(:all) { 30.times { create(:admin) } }
    after(:all)  { Admin.delete_all }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each user" do
        Admin.paginate(page: 1).each do |admin|
          page.should have_selector('li', text: admin.full_name)
        end
      end
    end

    describe "delete links" do
      it { should have_link(I18n.t('links.delete')) }

      it { should have_link(I18n.t('links.delete'), href: admin_path(Admin.first)) }
      it "should be able to delete another user" do
        expect { click_link(I18n.t('links.delete')) }.to change(Admin, :count).by(-1)
      end

      it { should_not have_link(I18n.t('links.delete'), href: admin_path(admin)) }
    end

  end

  describe "profile page" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { visit admin_path(admin) }

    it { should have_selector('h1', text: admin.full_name) }
    it { should have_title(full_title(admin.full_name)) }
  end

  describe "edit" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
      visit edit_admin_path(admin)
    end

    describe "page" do
      it { should have_selector('h2', text: I18n.t(:edit, model: Admin.model_name.human)) }
      it { should have_title(full_title(I18n.t(:edit, model: Admin.model_name.human))) }
    end

    describe "with invalid information" do
      before { click_button I18n.t('helpers.submit.update', model: Admin.model_name.human) }
      it { should have_content(I18n.t(:form_errors)) }
    end

    describe "with valid information" do
      let(:new_firstname) { "NewFirstname" }
      let(:new_lastname)  { "NewLastname" }
      let(:new_email)     { "new@example.com" }
      before do
        fill_in I18n.t('activerecord.attributes.admin.firstname'), with: new_firstname
        fill_in I18n.t('activerecord.attributes.admin.lastname'),  with: new_lastname
        fill_in I18n.t('activerecord.attributes.admin.email'),     with: new_email
        fill_in I18n.t('activerecord.attributes.admin.password'),  with: admin.password
        fill_in I18n.t(:confirm_password), with: admin.password
        click_button I18n.t('helpers.submit.update', model: Admin.model_name.human)
      end

      it { should have_title(I18n.t(:list_all, model: Client.model_name.human.pluralize)) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link(I18n.t('links.sign_out'), href: signout_path) }
      specify { admin.reload.firstname.should == new_firstname.capitalize }
      specify { admin.reload.lastname.should  == new_lastname.upcase }
      specify { admin.reload.email.should     == new_email }
    end
  end
end