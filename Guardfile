# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/rails_lite/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
end

