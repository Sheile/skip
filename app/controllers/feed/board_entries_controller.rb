class Feed::BoardEntriesController < ApplicationController
  layout false
  def index
  end

  def questions
    @entries = BoardEntry.publication_type_eq('public').question.visible.order_new.limit(25)
    respond_to do |format|
      format.atom { render :action => 'index' }
    end
  end

  def blogs
    @entries = BoardEntry.publication_type_eq('public').timeline.order_new.limit(25)
    respond_to do |format|
      format.atom { render :action => 'index' }
    end
  end

  def popular_blogs
    @entries = BoardEntry.publication_type_eq('public').timeline.diary.order_access.order_new.limit(25)
    respond_to do |format|
      format.atom { render :action => 'index' }
    end
  end

  def forums
    @entries = BoardEntry.publication_type_eq('public').timeline.forum.group_category_eq(params[:category]).order_new.limit(25)
    respond_to do |format|
      format.atom { render :action => 'index' }
    end
  end
end
