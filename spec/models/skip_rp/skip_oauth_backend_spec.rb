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

require File.dirname(__FILE__) + '/../../spec_helper'

describe SkipRp::SkipOauthBackend, '#add_access_token' do
  before do
    @app_name = 'wiki'
    @backend = SkipRp::SkipOauthBackend.new @app_name
  end
  describe 'identity_urlに一致するユーザが存在する場合' do
    before do
      @openid = 'http://example.com/id/boob'
      @bob = create_user :user_uid_options => {:uid => 'boob'}
    end
    describe '指定アプリに対する、対象ユーザのアクセストークンが登録済みの場合' do
      before do
        @bob.user_oauth_accesses.create! :app_name => @app_name, :token => 'token', :secret => 'secret' 
      end
      it 'user_oauth_accessesに登録されないこと' do
        lambda do
          @backend.add_access_token @openid, 'token', 'secret'
        end.should_not change(UserOauthAccess, :count)
      end
    end
    describe '指定アプリに対する、対象ユーザのアクセストークンが未登録の場合' do
      it 'user_oauth_accessesに登録されること' do
        lambda do
          @backend.add_access_token @openid, 'token', 'secret'
        end.should change(UserOauthAccess, :count).by(1)
      end
    end
  end
  describe 'identity_urlに一致するユーザが存在しない場合' do
    it 'user_oauth_accessesに登録されないこと' do
      lambda do
        @backend.add_access_token @openid, 'token', 'secret'
      end.should_not change(UserOauthAccess, :count)
    end
  end
end

