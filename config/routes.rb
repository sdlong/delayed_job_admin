Rails.application.routes.draw do
  get 'delayed_job_admin' => 'delayed_job_admin#index', :as => 'delayed_job_admin'
  get 'delayed_job_admin/restart' => 'delayed_job_admin#restart', :as => 'delayed_job_admin/restart'
  get 'delayed_job_admin/check_status' => 'delayed_job_admin#check_status', :as => 'delayed_job_admin/check_status'

  delete 'delayed_job_admin/delete' => 'delayed_job_admin#delete', :as => 'delete_job_delayed_job_admin', :method => :delete
  get 'delayed_job_admin/retry' => 'delayed_job_admin#retry_job', :as => 'retry_job_delayed_job_admin', :method => :put
  get 'delayed_job_admin/run_now' => 'delayed_job_admin#run_job_now', :as => 'run_job_now_delayed_job_admin', :method => :put

  patch 'delayed_job_admin/process' => 'delayed_job_admin#process_jobs', :as => 'process_jobs_delayed_job_admin', :method => :put
end
