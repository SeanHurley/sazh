class LoginController < ApplicationController
  def login
  end

  def start
    redirect_to home_index_path
  end
end
