class SurveysController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  def new
    whymail_id = params[:id]
    @whymail = Whymail.find(:first, :include => [:tickets, :user] , :conditions => ["id = ?", whymail_id] )
    @website = @whymail.website
    site = Website.find(:first, :conditions => ["url = ?", @website])||Website.create(:url => @website, :grade => 'NA', :rank => 100)
    if !site.nil? && site.save
      @survey = site.surveys.new(:opt_out => "false", :un_solicited=> "false", :sell=> "false", :vulgar=> "false", :give_out=> "false")
    else
      flash[:error] = configatron.bad_website
    end
    @user = @whymail.user
    render :partial => 'new'
  end



  def create
    whymail_id = params[:whymail]
    
    
    if current_user
      whymail = Whymail.find(:first, :include => :user, :conditions => ["id = ?", whymail_id])
      @website = whymail.website
      website = Website.find_or_create_by_url(@website)

      if params[:survey] != nil
        survey = website.surveys.create(params[:survey])
      end
      
     
      whymail.destroy if whymail.user == current_user
      flash[:notice] = configatron.thanks_for_reporting if !survey.nil?
      
   #   flash[:error] = "Please generate a NEW email every time you give out your email address, this survey has not been counted" if survey.nil?
      redirect_to :controller => 'websites', :action => 'show',  :url => @website
    else
      flash[:error] = configatron.bad_permissions      
      redirect_to :controller => "manage", :action => "index"
    end
  end
  
  

end