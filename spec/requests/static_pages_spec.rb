require 'spec_helper'

describe "StaticPages" do

    #変数
    let(:base_title) { "Ruby on Rails Tutorial Sample App" }

    describe "Static pages" do

        subject { page }

        shared_examples_for "all static pages" do
            it {should have_content(heading)}
            it {should have_title(full_title(page_title))}
        end

        ##------------------------------------
        #「/static_pages/homeのHomeページにアクセスしたとき、
        ##------------------------------------
        describe "Home page" do
            before { visit root_path }
            ##------------------------------------
            # “Sample App”という語が含まれていなければならない」
            let (:heading) { "Sample App" }
            let (:page_title) { '' }
            it_should_behave_like "all static pages"
            it { should_not have_title('| Home') }
        end

        ##------------------------------------
        #「/static_pages/helpのHelpページにアクセスしたとき、
        ##------------------------------------
        describe "Help page" do
            before { visit help_path }
            let (:heading) { "Help" }# “Help”という語が含まれていなければならない」
            let (:page_title) {'Help' }# title にHelpがある
            it_should_behave_like "all static pages"
        end

        ##------------------------------------
        #「/static_pages/aboutにアクセスしたとき
        ##------------------------------------
        describe "About page" do
            before { visit about_path }
            let (:heading) {"About Us"}
            let (:page_title) {"About Us"}
            it_should_behave_like "all static pages"
        end

        ##------------------------------------
        #「/static_pages/contact ページにアクセスしたとき、
        ##------------------------------------
        describe "Contact Page" do
            before { visit contact_path }
            let (:heading) { "Contact" }
            let (:page_title) { "Contact" }
            it_should_behave_like "all static pages"
        end

        it "should have the right links on the layout" do
            visit root_path
            click_link "About"
            expect(page).to have_title(full_title('About Us'))
            click_link "Help"
            expect(page).to have_title(full_title('Help'))
            click_link "Contact"
            expect(page).to have_title(full_title('Contact'))
            click_link "Home"
            click_link "Sign up now!"
            expect(page).to  have_title(full_title('Sign up'))
            click_link "sample app"
            expect(page).to  have_title(full_title(''))
        end
    end


    # describe "GET /static_pages" do
    #   it "works! (now write some real specs)" do
    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    # get static_pages_index_path
    # response.status.should be(200)
    # end


end
