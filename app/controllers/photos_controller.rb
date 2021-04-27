class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1 or /photos/1.json
  def show
    if @photo.owner.followers.include?(current_user)
      redirect_back fallback_location: root_url, alert: "nice try"
    end
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
    if current_user != @photo.owner
      redirect_back fallback_location: root_url, alert: "nice try"
    end
  end

  # POST /photos or /photos.json
  def create
    @photo = Photo.new(photo_params)
    @photo.owner = current_user

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    if current_user != @photo.owner
      redirect_back fallback_location: root_url, alert: "nice try"
    else
      respond_to do |format|
        if @photo.update(photo_params)
          format.html { redirect_to @photo, notice: "Photo was successfully updated." }
          format.json { render :show, status: :ok, location: @photo }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @photo.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  before_action :ensure_current_user_is_owner, only:[:destroy]

  # DELETE /photos/1 or /photos/1.json
  def destroy
    if current_user != @photo.owner
      redirect_back fallback_location: root_url, alert: "nice try"
    else
      @photo.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: root_url, notice: "Photo was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.require(:photo).permit(:image, :comments_count, :likes_count, :caption, :owner_id)
    end

    def ensure_current_user_is_owner
      if current_user != @photo.owner
        redirect_back fallback_location: root_url, alert: "nice try"
      else

    end
  end
end
