class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def index
  	@client = Offer.new FYBER_CONFIG
  	@offers = @client.offers({page: params[:page] || 1, uid: 'foo', pub0: 'bar', offer_types: 112})
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

end
