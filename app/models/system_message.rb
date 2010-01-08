# SKIP(Social Knowledge & Innovation Platform)
# Copyright (C) 2008-2009 TIS Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

class SystemMessage < ActiveRecord::Base
  belongs_to :user
  serialize :message_hash

  MESSAGE_TYPES = %w(COMMENT TRACKBACK CHAIN QUESTION JOIN LEAVE APPROVAL_OF_JOIN DISAPPROVAL_OF_JOIN FORCED_JOIN FORCED_LEAVE)

  def self.create_message attributes
    # TODO 既に対象のメッセージが作られている場合作られないようにする仕様を入れる。そもそも必要?
    create attributes
  end

  def processor
    @processor ||= self.class.processor_class(self.message_type).new(self)
  end

  def self.processor_class message_type
    case message_type
      when 'COMMENT' then CommentProcessor
      when 'TRACKBACK' then TrackbackProcessor
      when 'CHAIN' then ChainProcessor
      when 'QUESTION' then QuestionProcessor
      when 'JOIN' then JoinProcessor
      when 'LEAVE' then LeaveProcessor
      when 'APPROVAL_OF_JOIN' then ApprovalOfJoinProcessor
      when 'DISAPPROVAL_OF_JOIN' then DisapprovalOfJoinProcessor
      when 'FORCED_JOIN' then ForcedJoinProcessor
      when 'FORCED_LEAVE' then ForcedLeaveProcessor
    end
  end

  class AbstractProcessor
    include GetText
    attr_reader :message, :url_hash
  end

  class CommentProcessor < AbstractProcessor
    ICON = 'comments'
    DESCRIPTION = N_("Notify when a new comment was added.")

    def initialize message
      board_entry = BoardEntry.find(message.message_hash[:board_entry_id])
      @message = _("You recieved a comment on your entry [%s]!") % board_entry.title
      @url_hash = board_entry.get_url_hash
    end
  end

  class TrackbackProcessor < AbstractProcessor
    ICON = 'report_go'
    DESCRIPTION = N_("Notify when a new entry talking about your entry was created.")

    def initialize message
      board_entry = BoardEntry.find(message.message_hash[:board_entry_id])
      @message = _("There is a new entry talking about your entry [%s]!") % board_entry.title
      @url_hash = board_entry.get_url_hash
    end
  end

  class ChainProcessor < AbstractProcessor
    ICON = 'user_comment'
    DESCRIPTION = N_("Notify when you received an introduction.")

    def initialize message
      user = User.find(message.message_hash[:user_id])
      @message = _("You received an introduction!")
      @url_hash = {:controller => 'user', :uid => user.uid, :action => 'social', :menu => 'social_chain', :system_message_id => message.id}
    end
  end

  class QuestionProcessor < AbstractProcessor
    ICON = 'tick'
    DESCRIPTION = N_("Notify when the question status was changed.")

    def initialize message
      board_entry = BoardEntry.find(message.message_hash[:board_entry_id])
      @message = _('State of your question [%s] is changed!') % board_entry.title
      @url_hash = board_entry.get_url_hash
    end
  end

  class JoinProcessor < AbstractProcessor
    ICON = 'group_add'
    DESCRIPTION = N_("Notify when a user joined your group.")

    def initialize message
      group = Group.find(message.message_hash[:group_id])
      @message = _("New user joined your group [%s].") % group.name
      @url_hash = {:controller => 'group', :action => 'users', :gid => group.gid}
    end
  end

  class LeaveProcessor < AbstractProcessor
    ICON = 'group_delete'
    DESCRIPTION = N_("Notify when a user leaved your group.")

    def initialize message
      group = Group.find(message.message_hash[:group_id])
      user = User.find(message.message_hash[:user_id])
      @message = _("%{user_name} leaved your group %{group_name}.") % {:user_name => user.name, :group_name => group.name}
      @url_hash = {:controller => 'user', :action => 'show', :uid => user.uid}
    end
  end

  class ApprovalOfJoinProcessor < AbstractProcessor
    ICON = 'group_add'
    DESCRIPTION = N_("Notify when you were approved join of the group.")

    def initialize message
      board_entry = BoardEntry.find(message.message_hash[:board_entry_id])
      group = Group.find(message.message_hash[:group_id])
      user = User.find(message.message_hash[:user_id])
      @message = _("You were approved join of the group %s.") % group.name
      @url_hash = {:controller => 'group', :action => 'show', :gid => group.gid}
    end
  end

  class DisapprovalOfJoinProcessor < AbstractProcessor
    ICON = 'group_add'
    DESCRIPTION = N_("Notify when you were disapproved join of the group.")

    def initialize message
      group = Group.find(message.message_hash[:group_id])
      @message = _("You were disapproved join of the group %s.") % group.name
      @url_hash = {:controller => 'group', :action => 'show', :gid => group.gid}
    end
  end

  class ForcedJoinProcessor < AbstractProcessor
    ICON = 'group_add'
    DESCRIPTION = N_("Notify when you were forced to join the group.")

    def initialize message
      group = Group.find(message.message_hash[:group_id])
      @message = _("Forced to join the group [%s].") % group.name
      @url_hash = {:controller => 'group', :action => 'show', :gid => group.gid}
    end
  end

  class ForcedLeaveProcessor < AbstractProcessor
    ICON = 'group_delete'
    DESCRIPTION = N_("Notify when you were forced to leave the group.")

    def initialize message
      group = Group.find(message.message_hash[:group_id])
      @message = _("You forced to leave the group [%s].") % group.name
      @url_hash = {:controller => 'group', :action => 'users', :gid => group.gid}
    end
  end
end
