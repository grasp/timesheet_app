TimesheetApp::Admin.controllers :time_sheets do
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
end
