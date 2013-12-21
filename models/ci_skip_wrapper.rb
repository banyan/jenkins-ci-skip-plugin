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

      if changeset.getLogs().first.getComment() =~ /\[ci\sskip\]|\[skip\sci\]/
        listener.info "Commit message is included [ci skip]"
        build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
        build.halt("Build is skipped by ci-skip.")
      end
    rescue
      listener.error "Encountered exception when looking commit message: #{$!}"
      listener.error "Allowing build by default."
    end
  end
end
