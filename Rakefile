require 'spec/rake/spectask'

desc "Run specs"
Spec::Rake::SpecTask.new(:default) do |t|
  t.spec_opts = %w[--options spec/spec.opts] if File.exists?("spec/spec.opts")
  t.spec_files = FileList['spec/*_spec.rb']
end
