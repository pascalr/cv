class HomeController < ApplicationController
  def index
    @render_portfolio = true
  end
  def no_portfolio
    @render_portfolio = false
    render 'index'
  end
  def robot
  end
  def prog
  end
  def conception
  end
  def contact
  end
  def about
    @is_left = true
  end
end
