require 'Xcodeproj'

projectFile = "SomeApp.xcodeproj" #  ARGV[0]

project = Xcodeproj::Project.open(projectFile)

# for target in project.targets
#     for file in target.source_build_phase.files.to_a
#          puts file.file_ref.real_path.to_s 
#     end
# end

for object in project.objects
    if object.isa == "PBXFileReference"
        if object.last_known_file_type == "wrapper"
            puts object.path
        end
    end
end