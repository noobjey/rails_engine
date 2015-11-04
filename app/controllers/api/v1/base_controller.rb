class Api::V1::BaseController < ApplicationController

  def index(the_model)
    respond_with the_model.all
  end

  def show(the_model)
    respond_with the_model.find(params[:id])
  end

  def find(the_model)
    result = the_model.insensitive_find_by(allowed_params)

    respond_with result.nil? ? result : result.first
  end

  def find_all(the_model)
    respond_with the_model.where(allowed_params)
  end

  def random(the_model)
    result = the_model.all.sample(1)

    respond_with result.nil? ? result : result.first
  end
end
