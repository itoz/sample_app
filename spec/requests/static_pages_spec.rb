require 'spec_helper'

describe "StaticPages" do


    #変数
    let(:base_title) { "Ruby on Rails Tutorial Sample App" }


    describe "Static pages" do

        subject { page }

        ##------------------------------------
        #「/static_pages/homeのHomeページにアクセスしたとき、
        ##------------------------------------

        describe "Home page" do
            before { visit root_path }
            ##------------------------------------
            # “Sample App”という語が含まれていなければならない」
            it { should have_content('Sample App') }
            it { should have_title(full_title('')) }
            it { should_not have_title('| Home') }
        end

        ##------------------------------------
        #「/static_pages/helpのHelpページにアクセスしたとき、
        ##------------------------------------
        describe "Help page" do
            before { visit help_path }
            it { should have_content('Help') } # “Help”という語が含まれていなければならない」
            it { should have_title(full_title('Help'))} # title にHelpがある

        end

        ##------------------------------------
        #「/static_pages/aboutにアクセスしたとき
        ##------------------------------------
        describe "About page" do
            before { visit about_path }
            it { should have_content('About Us') }
            it { should have_title(full_title('About Us')) }
        end

        ##------------------------------------
        #「/static_pages/contact ページにアクセスしたとき、
        ##------------------------------------
        describe "Contact Page" do
            before { visit contact_path }
            it { should have_content('Contact') }
            it { should have_title(full_title('Contact')) }
        end
    end
    # describe "GET /static_pages" do
    #   it "works! (now write some real specs)" do
    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    # get static_pages_index_path
    # response.status.should be(200)


    # end
    # end
end
