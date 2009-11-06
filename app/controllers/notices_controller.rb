class NoticesController < ApplicationController

  verify :method => :post, :only => %w(create)

  def create
    target = target_user || target_group
    if target
      current_user.notices.create :target => target
      respond_to do |format|
        format.html do
          if target_user
            redirect_to url_for(:controller => 'user', :action => 'show', :uid => target_user.uid)
          elsif target_group
            redirect_to url_for(:controller => 'group', :action => 'show', :uid => target_group.gid)
          else
            redirect_to root_url
          end
        end
      end
    else
      render_404
    end
  end

  def destroy
    notice = current_user.notices.find params[:id]
    notice.destroy
    respond_to do |format|
      format.html do
        if target_user
          redirect_to url_for(:controller => 'user', :action => 'show', :uid => target_user.uid)
        elsif target_group
          redirect_to url_for(:controller => 'group', :action => 'show', :uid => target_group.gid)
        else
          redirect_to root_url
        end
      end
    end
  end

  private
  def target_user
    @target_usr ||= User.find_by_uid params[:uid]
  end

  def target_group
    @target_group ||= Grouo.find_by_gid params[:gid]
  end
end
