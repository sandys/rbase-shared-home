
#Building#
`sudo docker build . -t sss/r-base`

#Running#

`sudo docker run -ti   --rm -v "$HOME":/home/docker/ -w /home/docker/  -v /home/common:/home/common -v /r-libs:/r-libs -e LOCAL_USER_ID=$UID  -e R_LIBS_SITE=/r-libs sss/r-base R`

or 

`sudo docker run -ti   --rm -v "$HOME":/home/docker/ -w /home/docker/  -v /home/common:/home/common -v /r-libs:/r-libs -e LOCAL_USER_ID=$UID  -e R_LIBS_SITE=/r-libs sss/r-base /bin/bash`

This is a R image, which takes care of your install libraries being in a common area (*/r-libs*), shares your home directory to */home/docker*. It also installs rJava for those pesky mailR dependencies as well as a couple of system libraries.

The permissions issue is fixed using the *entrypoint.sh*

This particular docker VM can be used for other languages as well - like python, etc
