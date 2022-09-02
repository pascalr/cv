class ApplicationController < ActionController::Base
  def default_url_options(options={})
    {locale: 'fr'} # FIXME: Define constant elsewhere
  end
end
