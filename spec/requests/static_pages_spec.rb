require 'spec_helper'

describe "StaticPages" do


    describe "Static pages" do

        ##------------------------------------
        #「/static_pages/homeのHomeページにアクセスしたとき、
        ##------------------------------------

        describe "Home page" do

            ##------------------------------------
            # “Sample App”という語が含まれていなければならない」
            it "should have the content 'Sample App'" do
                visit '/static_pages/home'
                expect(page).to have_content('Sample App')
            end

            it "should have the title Home" do
                visit '/static_pages/home'
                expect(page).to have_title("Ruby on Rails Tutorial Sample App | Home")
            end
        end


        ##------------------------------------
        #「/static_pages/helpのHelpページにアクセスしたとき、
        ##------------------------------------
        describe "Help page" do


            ##------------------------------------
            # “Sample App”という語が含まれていなければならない」
            it "should have the content 'Help'" do
                visit '/static_pages/help'
                expect(page).to have_content('Help')
            end

            ##------------------------------------
            # title にHelpがある
            it "should have the title Help" do
                visit '/static_pages/help'
                expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
            end
        end


        ##------------------------------------
        #「/static_pages/aboutにアクセスしたとき
        ##------------------------------------

        describe "About page" do


            ##------------------------------------
            # About Usという文字列が、 含まれていなければならない」
            it "should have the content 'About Us'" do
                visit '/static_pages/about'
                expect(page).to have_content('About Us')
            end


            ##------------------------------------
            # title にAboutがある
            it "should have the title About" do
                visit '/static_pages/about'
                expect(page).to have_title("Ruby on Rails Tutorial Sample App | About Us")
            end

        end


        describe "Contact Page" do
            it "should have the content Contact" do
                visit '/static_pages/contact'
                expect(page).to have_content("Contact")
            end


            it "shoud have the title Contact" do
                visit "/static_pages/contact"
                expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
            end

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
