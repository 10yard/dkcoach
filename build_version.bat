set version=v0.21

set zip_path="C:\Program Files\7-Zip\7z"
del releases\dkcoach_plugin_%version%.zip

copy readme.md dkcoach\ /Y
%zip_path% a releases\dkcoach_plugin_%version%.zip dkcoach
del dkcoach\readme.md /Q