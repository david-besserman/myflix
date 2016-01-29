class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.owner?(queue_item)
    current_user.normalize_queue_item_position 
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_position 
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position number"
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position:  current_user.new_queue_item_position) unless current_user.queued_video?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        if queue_item.user == current_user
          queue_item.update!(position: queue_item_data["position"], rating: queue_item_data["rating"]) 
        end
      end
    end
  end

  def normalize_and_redirect
    current_user.normalize_queue_item_position 
    redirect_to my_queue_path
  end
end
