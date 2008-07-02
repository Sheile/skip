# SKIP（Social Knowledge & Innovation Platform）
# Copyright (C) 2008  TIS Inc.
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

require File.dirname(__FILE__) + '/../spec_helper'

describe BoardEntriesHelper do

  it "returns true when user_id is entry writer's id" do
    user_id = SkipFaker.rand_char
    comment = mock("comment")
    comment.stub!(:user_id).and_return(user_id)
    helper.writer?(comment, user_id).should be_true
  end

  it "returns false when user_id is not entry writer's id" do
    user_id = SkipFaker.rand_char
    comment = mock("comment")
    comment.stub!(:user_id).and_return(SkipFaker.rand_char)
    helper.writer?(comment, user_id).should be_false
  end

  it "returns true when comment writer" do
    user_id = SkipFaker.rand_char
    board_entry = mock("board_entry")
    board_entry.stub!(:user_id).and_return(user_id)
    comment = mock("comment")
    comment.stub!(:user_id).and_return(SkipFaker.rand_char)
    comment.stub!(:board_entry).and_return(board_entry)
    helper.comment_writer?(comment, user_id).should be_true
  end

  it "returns false when it is not comment and entry writer" do
    user_id = SkipFaker.rand_char
    board_entry = mock("board_entry")
    board_entry.stub!(:user_id).and_return(SkipFaker.rand_char)
    comment = mock("comment")
    comment.stub!(:user_id).and_return(SkipFaker.rand_char)
    comment.stub!(:board_entry).and_return(board_entry)
    helper.comment_writer?(comment, user_id).should be_false
  end
end
