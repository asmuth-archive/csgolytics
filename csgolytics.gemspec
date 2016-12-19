Gem::Specification.new do |s|
  s.name = "csgolytics"
  s.version = "0.0.6"
  s.authors = ["Paul Asmuth"]
  s.date = "2016-12-19"
  s.description = "CS:GO Analaytics with EventQL"
  s.summary = "CS:GO Analaytics with EventQL"
  s.email = "paul@eventql.io"
  s.files = Dir.glob("{bin,lib,db}/**/*") + %w(LICENSE README.md)
  s.executables = ["csgolytics-import"]
  s.homepage = "http://github.com/eventql/eventql"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.add_runtime_dependency "eventql", ">= 0.0.3"
end
