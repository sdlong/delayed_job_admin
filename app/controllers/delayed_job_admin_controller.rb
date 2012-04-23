class DelayedJobAdminController < ApplicationController

  # Delegate authetication to app controller
  before_filter :delayed_job_admin_authentication

  def index

    # Display status when delayed_job_admin_check_status
    # is implemented
    if respond_to? 'delayed_job_admin_check_status'
      @status = if params[:current_status].to_s.include?( "delayed_job:" )
          if params[:current_status].to_s.include?( "running" )
            params[:current_status].to_s.sub("delayed_job", "Status")
          elsif params[:current_status].to_s.include?("no")
            "no"
          end
      end
    end

    @jobs = Delayed::Job.page(params[:page]).order("run_at desc")

    render :layout => DelayedJobAdmin.layout

  end

  def restart
    # Delegate authetication to app controller
    delayed_job_admin_restart
    redirect_to :action => 'index', :current_status => @status
  end

  def check_status
	# Delegate authetication to app controller
    delayed_job_admin_check_status
    redirect_to :action => 'index', :current_status => @status
  end

  def delete
    if job = Delayed::Job.find(params[:job_id])
      #job.attempts = 10
      #job.save
      job.destroy
    end
    redirect_to :action => 'index'
  end
  
  def run_job_now
    if job = Delayed::Job.where("failed_at IS NULL").find_by_id(params[:job_id])
      job.run_at = Time.now
      job.save
    end
    redirect_to delayed_job_admin_path
  end

  def retry_job
    if job = Delayed::Job.where("failed_at IS NOT NULL").find_by_id(params[:job_id])
      job.run_at = Time.now
      job.failed_at = nil
      job.locked_at = nil
      job.locked_by = nil
      job.save
    end
    redirect_to delayed_job_admin_path
  end
  
  def process_jobs
     if !params[:jobs].nil?  
    if params[:commit] == "reset selected jobs"
     
        jobs = Delayed::Job.where(:id => params[:jobs])
        jobs.update_all(:attempts => 0, :locked_at => nil, :failed_at => nil, :locked_by => nil)
     
    elsif params[:commit] == "delete selected jobs"
       jobs = jobs = Delayed::Job.where(:id => params[:jobs])
       jobs.delete_all
    end   
    end   
    redirect_to :back
  end  
end