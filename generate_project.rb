require "xcodeproj"

project_path = "PaperAccept.xcodeproj"
project = Xcodeproj::Project.new(project_path)
target = project.new_target(:application, "PaperAccept", :ios, "17.0")

source_group = project.main_group.new_group("PaperAccept", "PaperAccept")
Dir.glob("PaperAccept/*.swift").sort.each do |file_path|
  file_ref = source_group.new_file(File.basename(file_path))
  target.add_file_references([file_ref])
end

assets_path = "PaperAccept/Assets.xcassets"
if File.directory?(assets_path)
  assets_ref = source_group.new_file("Assets.xcassets")
  target.add_resources([assets_ref])
end

target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.gaogehan.PaperAccept"
  config.build_settings["PRODUCT_NAME"] = "PaperAccept"
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "YES"
  config.build_settings["INFOPLIST_KEY_CFBundleDisplayName"] = "PaperAccept"
  config.build_settings["INFOPLIST_KEY_UILaunchScreen_Generation"] = "YES"
  config.build_settings["INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents"] = "YES"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  config.build_settings["SWIFT_VERSION"] = "6.0"
  config.build_settings["SWIFT_EMIT_LOC_STRINGS"] = "YES"
  config.build_settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"
  config.build_settings["ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME"] = "AccentColor"
  config.build_settings["CODE_SIGN_STYLE"] = "Automatic"
  config.build_settings["DEVELOPMENT_TEAM"] = ""
end

project.save
project.recreate_user_schemes
