#!/bin/bash

echo "Configuring dockers"
docker network create webcheckr
docker build -t webcheckr .
docker create --net=webcheckr --name cvesearch_docker ttimasdf/cve-search:withdb

echo "Creating file in /usr/local/sbin/webcheckr (need sudo)"
sudo tee -a /usr/local/sbin/webcheckr<<EOF
#!/bin/bash

docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}:/webcheckr --user $(id -u):$(id -g) --group-add $(stat -c '%g' /var/run/docker.sock) --net webcheckr webcheckr $@

EOF
sudo chmod u+x /usr/local/bin/webcheckr

echo "Finished"
