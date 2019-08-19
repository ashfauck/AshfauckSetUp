
Pod::Spec.new do |spec|
spec.name = "AshfauckSetUp"
spec.version = "1.0.0"
spec.summary = "Framework for users who would like to start their project from high level structure."
spec.homepage = "https://github.com/ashfuack/AshfauckSetUp"
spec.license = { type: 'MIT', file: 'LICENSE' }
spec.authors = { "Ashfauck Thaminsali" => 'ashfauck@gmail.com' }
spec.social_media_url = "https://github.com/ashfuack/AshfauckSetUp"

spec.platform = :ios, "11.0"
spec.requires_arc = true
spec.swift_version = "5.0"
# spec.source = { git: "https://github.com/ashfuack/AshfauckSetUp.git", tag: "v#{spec.version}", submodules: false }
spec.source = { :git => "https://github.com/ashfuack/AshfauckSetUp" }

spec.source_files = "AshfauckSetUp/**/*.{h,swift}"


end
