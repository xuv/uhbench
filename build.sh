#!/bin/bsh

# SETTINGS

# This coresponds to the names used for the scenes in the .blend file. Oviously, odn't use space in your names.
STEPS=(step0 step1 step2 step3 step4 step5 step6 step7 step8)
BUILD_DIR=build

for s in ${STEPS[@]}
do
	# Launch Blender render for selected scene
	blender -b uhbench.blend  -S ${s} --render-output //${BUILD_DIR}/${s}_ -f 1
	
	# Remove extra "fills" in the SVG
	# This line should be removed once Freestyle-SVG-exporter handles toggling "Contour Fills" per lineset
	xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" -d "//svg:g[@id='RenderLayer_InLine']/svg:g[@id='fills']" ${BUILD_DIR}/${s}_0001.svg 
done

# Clean up remove unused files
echo "Cleaning up..."
rm ${BUILD_DIR}/*.png

# Generate a gif ;)
echo "Creating animated GIF..."
convert -delay 100 -loop 0 ${BUILD_DIR}/step*.svg uHbench-loop.gif

echo "Done"