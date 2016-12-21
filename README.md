# Semantic-Mapping

Our code runs the 'depthToCloud_full_RGB function so make sure that it is in the same directory as well as the 'params' and 'Data' folders.
the data must have the same path within the 'Data' folder as it does in the google drive.

The script segment_all.m will run the segmentation through every image set and return all the cloud points as cell arrays with the points array and the color array.  (takes a very long time)

you can also run each script individually giving it the start, end and step to go through the images

next you can call the make_model function using one of your point cell arrays to run through ICP and make the model, the step is to step through some of the point clouds as using all of them is usually overkill, we usually stepped by 10.

we have also included some pre-segmented cloud points and completed models, as the whole program can take a while to run, as .mat files
