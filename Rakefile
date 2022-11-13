require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
    t.libs << "tests"
    t.libs << "app"
    t.warning = false
    t.test_globs = ["tests/**/*_test.rb"]
end

task :main do
    ruby "./main.rb"
end

task default: %i[main]
