echo ----------------------------------------------------------------------------------------------
echo  Package the dkcoach plugin 
echo ----------------------------------------------------------------------------------------------
copy readme.md dkcoach\ /Y

echo **** package into a release ZIP getting the version from version.txt
set /p version=<VERSION
set zip_path="C:\Program Files\7-Zip\7z"
del releases\dkcoach_plugin_%version%.zip
%zip_path% a releases\dkcoach_plugin_%version%.zip .\dkcoach\*