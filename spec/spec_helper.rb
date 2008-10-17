# SKIP(Social Knowledge & Innovation Platform)
# Copyright (C) 2008 TIS Inc.
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

# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rubygems'
require 'test/unit'
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = true
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

def admin_login
  session[:user_code] = '111111'
  session[:prepared] = true
  u = stub_model(User)
  u.stub!(:admin).and_return(true)
  u.stub!(:active?).and_return(true)
  if defined? controller
    controller.stub!(:current_user).and_return(u)
  else
    # helperでも使えるように
    stub!(:current_user).and_return(u)
  end
  u
end

def user_login
  session[:user_code] = '111111'
  session[:prepared] = true
  u = stub_model(User)
  up = stub_model(UserProfile)
  u.stub!(:admin).and_return(false)
  u.stub!(:active?).and_return(true)
  u.stub!(:name).and_return('ユーザ')
  u.stub!(:crypted_password).and_return('123456789')
  u.stub!(:user_profile).and_return(up)
  if defined? controller
    controller.stub!(:current_user).and_return(u)
  else
    # helperでも使えるように
    stub!(:current_user).and_return(u)
  end
  u
end

def mock_record_invalid
  fa = mock_model(ActiveRecord::Base)
  fa.errors.stub!(:full_messages).and_return([])
  ActiveRecord::RecordInvalid.new(fa)
end

def create_ranking(options = {})
  ranking = Ranking.new({
    :url => 'http://user.openskip.org/',
    :title => 'SUG',
    :extracted_on => Date.today,
    :amount => 1,
    :contents_type => 'entry_access'}.merge(options))
  ranking.save
  ranking
end

def create_user options = {}
  options[:user_options] ||= {}
  user = User.new({ :name => 'ほげ ほげ', :password => 'password', :password_confirmation => 'password', :password_reset_token => nil}.merge(options[:user_options]))
  user.status = options[:status] || 'ACTIVE'
  if options[:user_profile_options]
    user_profile = UserProfile.new({ :email => 'example@skip.org', :section => 'Programmer', :disclosure => true }.merge(options[:user_profile_options]))
    user.user_profile = user_profile
  end
  if options[:user_uid_options]
    user_uid = UserUid.new({ :uid => '123456', :uid_type => 'MASTER' }.merge(options[:user_uid_options]))
    user.user_uids << user_uid
  end
  user.save!
  user
end

def unused_user_login
  session[:user_code] = '111111'
  session[:prepared] = true
  u = stub_model(User)
  up = stub_model(UserProfile)
  u.stub!(:admin).and_return(false)
  u.stub!(:active?).and_return(false)
  u.stub!(:unused?).and_return(true)
  u.stub!(:name).and_return('未登録ユーザ')
  u.stub!(:crypted_password).and_return('123456789')
  u.stub!(:user_profile).and_return(up)
  if defined? controller
    controller.stub!(:current_user).and_return(u)
  else
    # helperでも使えるように
    stub!(:current_user).and_return(u)
  end
  u
end

def valid_group_category
  group_category = GroupCategory.new({
    :code => 'DEPT',
    :name => '部署',
    :icon => 'group_gear',
    :description => '部署用のグループカテゴリ',
    :initial_selected => false
  })
  group_category
end

def create_group_category(options = {})
  group_category = valid_group_category
  group_category.attributes = options
  group_category.save!
  group_category
end

def create_board_entry options = {}
  board_entry = BoardEntry.new({:title => 'とある記事',
                               :contents => 'とある記事の内容',
                               :date => Date.today,
                               :user_id => 1,
                               :last_updated => Date.today,
                               :publication_type => 'public'}.merge(options))
  board_entry.save!
  create_entry_publications(:board_entry_id => board_entry.id, :symbol => Symbol::SYSTEM_ALL_USER) if board_entry.public?
  board_entry
end

def create_entry_publications options = {}
  entry_publication = EntryPublication.new({:board_entry_id => 1, :symbol => ''}.merge(options))
  entry_publication.save!
  entry_publication
end

def create_board_entry_comment options = {}
  board_entry_comment = BoardEntryComment.new({:board_entry_id => 1,
                                               :contents => 'とあるコメント',
                                               :user_id => 1}.merge(options))
  board_entry_comment.save!
  board_entry_comment
end

def mock_uploaed_file options = {}
  file = mock('file', { :original_filename => "file1.png", :content_type => "text", :size => 1000, :read => "" }.merge(options))
  file.stub!(:is_a?).with(ActionController::UploadedFile).and_return(true)
  # 以下をやらないとパラメータの中身がHashかどうかのチェックがらしく、リクエストが飛ばなくなるので
  file.stub!(:is_a?).with(Hash).and_return(false)
  file
end

######skip関連のテストで必要
class ApplicationController;skip_before_filter :sso; end
