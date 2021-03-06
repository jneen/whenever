require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class OutputDefinedJobTest < Test::Unit::TestCase
  
  context "A defined job with a :task" do
    setup do
      @output = Whenever.cron \
      <<-file
        job_type :some_job, "before :task after"
        every 2.hours do
          some_job "during"
        end
      file
    end
    
    should "output the defined job with the task" do
      assert_match /^.+ .+ .+ .+ before during after$/, @output
    end
  end
  
  context "A defined job with a :task and some options" do
    setup do
      @output = Whenever.cron \
      <<-file
        job_type :some_job, "before :task after :option1 :option2"
        every 2.hours do
          some_job "during", :option1 => 'happy', :option2 => 'birthday'
        end
      file
    end
    
    should "output the defined job with the task and options" do
      assert_match /^.+ .+ .+ .+ before during after happy birthday$/, @output
    end
  end
  
  context "A defined job with a :task and an option where the option is set globally" do
    setup do
      @output = Whenever.cron \
      <<-file
        job_type :some_job, "before :task after :option1"
        set :option1, 'happy'
        every 2.hours do
          some_job "during"
        end
      file
    end
    
    should "output the defined job with the task and options" do
      assert_match /^.+ .+ .+ .+ before during after happy$/, @output
    end
  end
  
  context "A defined job with a :task and an option where the option is set globally and locally" do
    setup do
      @output = Whenever.cron \
      <<-file
        job_type :some_job, "before :task after :option1"
        set :option1, 'global'
        every 2.hours do
          some_job "during", :option1 => 'local'
        end
      file
    end
    
    should "output the defined job using the local option" do
      assert_match /^.+ .+ .+ .+ before during after local$/, @output
    end
  end
  
  context "A defined job with a :task and an option that is not set" do
    setup do
      @output = Whenever.cron \
      <<-file
        job_type :some_job, "before :task after :option1"
        every 2.hours do
          some_job "during", :option2 => 'happy'
        end
      file
    end
    
    should "output the defined job with that option removed" do
      assert_match /^.+ .+ .+ .+ before during after$/, @output
    end
  end

end