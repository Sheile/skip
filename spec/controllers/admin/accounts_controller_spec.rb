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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AccountsController do
  before do
    admin_login
  end
  describe "handling GET /admin_accounts" do

    before(:each) do
      @account = mock_model(Admin::Account)
      Admin::Account.stub!(:find).and_return([@account])
    end

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should find all admin_accounts" do
      Admin::Account.should_receive(:find).and_return([@account])
      do_get
    end

    it "should assign the found admin_accounts for the view" do
      do_get
      assigns[:accounts].should == [@account]
    end
  end

  describe "handling GET /admin_accounts.xml" do

    before(:each) do
      @accounts = mock("Array of Admin::Accounts", :to_xml => "XML")
      Admin::Account.stub!(:find).and_return(@accounts)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all admin_accounts" do
      Admin::Account.should_receive(:find).and_return(@accounts)
      do_get
    end

    it "should render the found admin_accounts as xml" do
      @accounts.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin_accounts/1" do

    before(:each) do
      @account = mock_model(Admin::Account)
      Admin::Account.stub!(:find).and_return(@account)
    end

    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find the account requested" do
      Admin::Account.should_receive(:find).with("1").and_return(@account)
      do_get
    end

    it "should assign the found account for the view" do
      do_get
      assigns[:account].should equal(@account)
    end
  end

  describe "handling GET /admin_accounts/1.xml" do

    before(:each) do
      @account = mock_model(Admin::Account, :to_xml => "XML")
      Admin::Account.stub!(:find).and_return(@account)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find the account requested" do
      Admin::Account.should_receive(:find).with("1").and_return(@account)
      do_get
    end

    it "should render the found account as xml" do
      @account.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin_accounts/new" do

    before(:each) do
      @account = mock_model(Admin::Account)
      Admin::Account.stub!(:new).and_return(@account)
    end

    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render new template" do
      do_get
      response.should render_template('new')
    end

    it "should create an new account" do
      Admin::Account.should_receive(:new).and_return(@account)
      do_get
    end

    it "should not save the new account" do
      @account.should_not_receive(:save)
      do_get
    end

    it "should assign the new account for the view" do
      do_get
      assigns[:account].should equal(@account)
    end
  end

  describe "handling GET /admin_accounts/1/edit" do

    before(:each) do
      @account = mock_model(Admin::Account)
      Admin::Account.stub!(:find).and_return(@account)
    end

    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should find the account requested" do
      Admin::Account.should_receive(:find).and_return(@account)
      do_get
    end

    it "should assign the found Admin::Account for the view" do
      do_get
      assigns[:account].should equal(@account)
    end
  end

  describe "handling POST /admin_accounts" do

    before(:each) do
      @account = mock_model(Admin::Account, :to_param => "1")
      Admin::Account.stub!(:new).and_return(@account)
    end

    describe "with successful save" do

      def do_post
        @account.should_receive(:save).and_return(true)
        post :create, :admin_account => {}
      end

      it "should create a new account" do
        Admin::Account.should_receive(:new).with({}).and_return(@account)
        do_post
      end

      it "should redirect to the new account" do
        do_post
        response.should redirect_to(admin_account_url("1"))
      end

    end

    describe "with failed save" do

      def do_post
        @account.should_receive(:save).and_return(false)
        post :create, :account => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /admin_accounts/1" do

    before(:each) do
      @account = mock_model(Admin::Account, :to_param => "1")
      Admin::Account.stub!(:find).and_return(@account)
    end

    describe "with successful update" do

      def do_put
        @account.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the account requested" do
        Admin::Account.should_receive(:find).with("1").and_return(@account)
        do_put
      end

      it "should update the found account" do
        do_put
        assigns(:account).should equal(@account)
      end

      it "should assign the found account for the view" do
        do_put
        assigns(:account).should equal(@account)
      end

      it "should redirect to the account" do
        do_put
        response.should redirect_to(admin_account_url("1"))
      end

    end

    describe "with failed update" do

      def do_put
        @account.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /admin_accounts/1" do

    before(:each) do
      @account = mock_model(Admin::Account, :destroy => true)
      Admin::Account.stub!(:find).and_return(@account)
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the account requested" do
      Admin::Account.should_receive(:find).with("1").and_return(@account)
      do_delete
    end

    it "should call destroy on the found account" do
      @account.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the admin_accounts list" do
      do_delete
      response.should redirect_to(admin_accounts_url)
    end
  end
end

describe Admin::AccountsController do
  before do
    admin_login
  end

  describe "GET index" do
    describe "条件がない場合" do
      before do
        @accounts = (1..3).map{|i| mock_model(Admin::Account)}
        Admin::Account.should_receive(:find).and_return(@accounts)
        get :index
      end
      it "@accountsが設定されていること" do
        assigns[:accounts].should equal(@accounts)
      end

      it "indexがレンダリングされること" do
        response.should render_template('admin/accounts/index')
      end

    end

    describe "検索条件がある場合" do
      before do
        @query = 'hoge'
        @accounts = (1..3).map{|i| mock_model(Admin::Account)}
        conditions = [Admin::Account.search_colomns, {:lqs => SkipUtil.to_lqs(@query)}]
        Admin::Account.should_receive(:find).with(:all, :conditions => conditions).and_return(@accounts)
        get :index, :query => @query
      end

      it "@accountsが設定されていること" do
        assigns[:accounts].should equal(@accounts)
      end

      it "@queryが設定されていること" do
        assigns[:query].should equal(@query)
      end
    end
  end
end
