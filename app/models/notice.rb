class Notice < ActiveRecord::Base
  belongs_to :target, :polymorphic => true

  # TODO 複雑過ぎるのでもっと簡単にして回帰テストを書きたい
  def self.systems user
    antennas = []

    antennas << { :name => _("Notices for you"), :user_id => user.id, :type => 'message', :count => BoardEntry.accessible(user).notice.unread(user).count }

    # コメントの行方
    find_params = BoardEntry.make_conditions(user.belong_symbols)
    find_params[:conditions][0] << " and user_readings.read = ? and user_readings.user_id = ?"
    find_params[:conditions] << false << user.id
    find_params[:conditions][0] << " and board_entry_comments.user_id = ?"
    find_params[:conditions] << user.id
    comment_count = BoardEntry.count(
      :conditions => find_params[:conditions],
      :include => find_params[:include] | [:user_readings, :board_entry_comments]
    )
    antennas << { :name => _("Trace Comments"), :user_id => user.id, :type => 'comment', :count => comment_count }

    # ブクマの行方 /page/% をブクマしている人のみに表示する
    if (bookmarks = Bookmark.find(:all,
                                  :conditions => ["bookmark_comments.user_id = ? and url like '/page/%'", user.id],
                                  :include => [:bookmark_comments])).size > 0
      urls = UserReading.find(:all,
                              :select => "board_entry_id",
                              :conditions => ["user_readings.read = ? and user_id = ?", false, user.id])
      urls.map! {|item| '/page/'+item.board_entry_id.to_s }

      bookmark_count = 0
      bookmarks.each { |bookmark| bookmark_count+=1 if urls.include?(bookmark.url) } if urls.size > 0
      antennas << {:name => _("Track of Bookmarks"), :user_id => user.id, :type => 'bookmark', :count => bookmark_count }
    end

    if user.group_symbols.size > 0
      find_params = BoardEntry.make_conditions user.belong_symbols, { :symbols => user.group_symbols}
      find_params[:conditions][0] << " and user_readings.read = ? and user_readings.user_id = ?"
      find_params[:conditions] << false << user.id
      group_count = BoardEntry.count(
        :conditions => find_params[:conditions],
        :include => find_params[:include] | [:user_readings]
      )
      antennas << {:name => _("Your Groups"), :user_id => user.id, :type => 'joined_group', :count => group_count }
    end
    antennas
  end

  def unread_count user
    BoardEntry.accessible(user).owned(target).unread(user).count
  end
end
