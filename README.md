
#Building#
`sudo docker build . -t sss/r-base`

#Running#

`sudo docker run -ti   --rm -v "$HOME":/home/docker/ -w /home/docker/  -v /home/common:/home/common -v /r-libs:/r-libs -e LOCAL_USER_ID=$UID  -e R_LIBS_SITE=/r-libs sss/r-base R`
or 

`sudo docker run -ti   --rm -v "$HOME":/home/docker/ -w /home/docker/  -v /home/common:/home/common -v /r-libs:/r-libs -e LOCAL_USER_ID=$UID  -e R_LIBS_SITE=/r-libs sss/r-base /bin/bash`
