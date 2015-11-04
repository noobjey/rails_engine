class Api::V1::BaseController < ApplicationController

  def index(the_model)
    respond_with the_model.all
  end

  def show(the_model)
    respond_with the_model.find(params[:id])
  end

  def find(the_model)
    respond_with the_model.insensitive_find_by(allowed_params).first
  end

  def find_all(the_model)
    respond_with the_model.where(allowed_params)
  end

  def random(the_model)
    respond_with the_model.all.sample(1).first
  end
end
