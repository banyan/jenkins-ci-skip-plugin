require 'ci_skip/matcher'

class CiSkipWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Enable ci-skip"
  attr_accessor :ci_skip

  def initialize(attrs)
    @ci_skip = attrs['ci_skip']
  end

  def setup(build, launcher, listener)
    begin
      changeset = build.native.getChangeSet()

      if changeset.isEmptySet()
        listener.info "Empty changeset, running build."
        return
      end

      logs = changeset.getLogs()
      latest_commit = logs.get(logs.size - 1)
      if latest_commit.respond_to?(:getComment)
        comment = latest_commit.getComment()
      elsif latest_commit.respond_to?(:getMsg)
        comment = latest_commit.getMsg()
      end

      if CiSkip::Matcher.new(comment).skip?
        listener.info "Build is skipped through commit message."
        if latest_commit.respond_to?(:getCommitId)
          listener.info "Commit: #{latest_commit.getCommitId()}"
        elsif latest_commit.respond_to?(:getNode)
          listener.info "Commit: #{latest_commit.getNode()}"
        else
          listener.info "Commit: version/id unknown"
        end
        listener.info "Message: #{comment}"
        halt(build)
      end
    rescue
      listener.error "Encountered exception when looking commit message: #{$!}"
      listener.error "Allowing build by default."
    end
  end

  private
  def halt(build)
    build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
    build.halt("Build is skipped by ci-skip.")
  end
end
