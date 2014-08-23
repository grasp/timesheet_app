TimesheetApp::App.controllers :time_sheets do
  enable :reload
  puts "reload controller time_sheets"
  layout  Padrino.root("admin","views","application.haml")  

  get :index do
    @title = "Time_sheets"
    @time_sheets = TimeSheet.all
    render 'time_sheets/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'time_sheet')
    @time_sheet = TimeSheet.new
    render 'time_sheets/new'
  end

  post :create do
    @time_sheet = TimeSheet.new(params[:time_sheet])
    if @time_sheet.save
      @title = pat(:create_title, :model => "time_sheet #{@time_sheet.id}")
      flash[:success] = pat(:create_success, :model => 'TimeSheet')
      params[:save_and_continue] ? redirect(url(:time_sheets, :index)) : redirect(url(:time_sheets, :edit, :id => @time_sheet.id))
    else
      @title = pat(:create_title, :model => 'time_sheet')
      flash.now[:error] = pat(:create_error, :model => 'time_sheet')
      render 'time_sheets/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "time_sheet #{params[:id]}")
    @time_sheet = TimeSheet.find(params[:id])
    if @time_sheet
      render 'time_sheets/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'time_sheet', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "time_sheet #{params[:id]}")
    @time_sheet = TimeSheet.find(params[:id])
    if @time_sheet
      if @time_sheet.update_attributes(params[:time_sheet])
        flash[:success] = pat(:update_success, :model => 'Time_sheet', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:time_sheets, :index)) :
          redirect(url(:time_sheets, :edit, :id => @time_sheet.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'time_sheet')
        render 'time_sheets/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'time_sheet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Time_sheets"
    time_sheet = TimeSheet.find(params[:id])
    if time_sheet
      if time_sheet.destroy
        flash[:success] = pat(:delete_success, :model => 'Time_sheet', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'time_sheet')
      end
      redirect url(:time_sheets, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'time_sheet', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Time_sheets"
    unless params[:time_sheet_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'time_sheet')
      redirect(url(:time_sheets, :index))
    end
    ids = params[:time_sheet_ids].split(',').map(&:strip)
    time_sheets = TimeSheet.find(ids)
    
    if TimeSheet.destroy time_sheets
    
      flash[:success] = pat(:destroy_many_success, :model => 'Time_sheets', :ids => "#{ids.to_sentence}")
    end
    redirect url(:time_sheets, :index)
  end


  get :new_login_logout,:map=>"/" do
    @title="打卡神器"
    @all_user=["Hunter","Frank","ZhengYong"]
    @working_status_hash=Hash.new
    @all_user.each do |user_name|
      @working_status_hash[user_name]||=Hash.new
      @working_status_hash[user_name]["count"]=TimeSheet.where(:user_name=>user_name).count
      @working_status_hash[user_name]["total_hour"]=TimeSheet.where(:user_name=>user_name).sum(:real_minutes)
      #@working_status_hash[user_name]["week_count"]=TimeSheet.where(:conditions =>["start_time >= ? AND user_name = ? ",7.days.from_now.to_s,user_name]).count
      @working_status_hash[user_name]["week_count"]=TimeSheet.where(created_at: (Time.now - 7.day)..Time.now).where(:user_name=>user_name).count
       @working_status_hash[user_name]["month_count"]=TimeSheet.where(created_at: (Time.now - 30.day)..Time.now).where(:user_name=>user_name).count
      timesheet=TimeSheet.where(:user_name=>user_name).order(created_at: :desc).first
      if timesheet.nil?
       @working_status_hash[user_name]["working_status"]="idle"
     elsif timesheet.end_time.nil?
       @working_status_hash[user_name]["working_status"]="onworking"

       @working_status_hash[user_name]["plan_item"]=timesheet.plan_item
     else
      @working_status_hash[user_name]["working_status"]="idle"
      #puts "plan_item #{user_name} =#{@working_status_hash[user_name]["plan_item"]}"
      end
    end

    render "new_login_logout"
  end


  post :start_working do 
    flash[:warning] ="哇！ 开始工作了,我们一定可以做出一个好的产品！"
    timesheet=TimeSheet.new
    start_time=Time.now.to_s
    plan_item="开发" if params[:plan_item].nil? || params[:plan_item].size==0
    TimeSheet.create("user_name"=>params[:user_name],:plan_item=>plan_item,:start_time=>Time.now.to_s)
    redirect(url(:time_sheets, :new_login_logout)) 
  end

  post :end_working do 
    flash[:warning] ="休息一下吧，准备下一次冲锋！"
   timesheet=TimeSheet.where(:user_name=>params[:user_name]).order(created_at: :desc).first
   start_time=Time.parse(timesheet.start_time)
   end_time=Time.now
   real_minutes=(end_time-start_time)/60
   if real_minutes>60*12
    flash[:warning] ="哈哈， 你忘记点结束工作了，本次打卡只能算一个小时！"
    real_minutes=60
   end

   timesheet.update_attributes(:end_time=>end_time.to_s,:real_minutes=>real_minutes)
   redirect(url(:time_sheets, :new_login_logout)) 
  end


  get :user_history,:map=>"time_sheets/user_history/:user_name" do
  
    @time_sheets=TimeSheet.where(:user_name=>params[:user_name]).order(created_at: :desc)
    render "time_sheets/user_history"

  end
end
