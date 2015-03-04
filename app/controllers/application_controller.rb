class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    #特に、いくつかのサインイン関数についてはコントローラとビューのどちらからも使用できるようにする必要があるのでinclude
    include SessionsHelper
end
