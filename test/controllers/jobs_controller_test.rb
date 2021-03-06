require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @available_jobs = create_list(:job, 3)
    @archived_job = create(:job, archived: true) # one archived job
  end

  test "should get index" do
    get jobs_url

    assert_response :success

    @available_jobs.each do |job|
      job_title = "#{job.role} at #{job.company}"
      assert_match job_title, @response.body
    end

    # archived jobs are not displayed
    archived_job_title = "#{@archived_job.role} at #{@archived_job.company}"
    refute_match archived_job_title, @response.body
  end

  test "should show a job" do
    job = @available_jobs.first

    get job_url(job)

    assert_response :success
    assert_match job.company,       @response.body
    assert_match job.role,          @response.body
    assert_match job.qualification, @response.body
    assert_match job.salary,        @response.body
    assert_match job.duration,      @response.body
  end

  test "should not find archived job" do
    assert_raise ActionController::RoutingError do
      get job_url(@archived_job)
    end
  end
end
