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
      comment = latest_commit.getComment()

      if CiSkip::Matcher.new(comment).skip?
        listener.info "Build is skipped through commit message."
        listener.info "Commit: #{latest_commit.getCommitId()}"
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
