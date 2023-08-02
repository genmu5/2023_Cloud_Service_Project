ENVFILE="./env.txt"
USRFILE="./username.txt"
result=baepo.yaml
usrname=""
if [ -e "$USRFILE" ]; then
	usrname=$(grep -o '^[^@]*' "$USRFILE")
fi
echo $usrname
if [ -e "$ENVFILE" ]; then
	touch $result
	echo apiVersion: apps/v1 > $result
	echo kind: Deployment >> $result
	echo metadata: >> $result
	echo "  name: web-deployment" >> $result
	echo spec: >> $result
	echo "  selector:" >> $result
	echo "    matchLabels:" >> $result
	echo "      app: baepo" >> $result
	echo "  replicas: 3" >> $result
	echo "  template:" >> $result
	echo "    metadata:" >> $result
	echo "      labels:" >> $result
	echo "        app: baepo" >> $result
	echo "    spec:" >> $result
	echo "      containers:" >> $result
	filenv=$(cat "$ENVFILE" | grep -o .)
	count=0
	for i in $filenv; do
		if [ $i -eq 1 ]; then
			case $count in
			0) 	echo apache
				;;
			1) 	echo nginx
				echo "        - name: frontend" >> $result
				echo "          image: iad.ocir.io/iddh4z5bswsv/test:${usrname}frontimage" >> $result
				echo "          ports:" >> $result
				echo "            - containerPort: 80" >> $result
				;;
			2) 	echo bootstrap
				mkdir frontend && mv ./*.html ./frontend && mv ./*.css ./frontend && mv ./*.js ./frontend
				;;
			7)	echo mysql
            	mkdir sql && mv ./*.sql ./sql
                sudo cp -r ./sql /nfs-mount
				;;
			11)	echo python
				mkdir backend && mv *.py backend/ && mv requirements.txt backend/
				echo "        - name: backend" >> $result
				echo "          image: iad.ocir.io/iddh4z5bswsv/test:${usrname}backimage" >> $result
				echo "          ports:" >> $result
				echo "          - containerPort: 8080" >> $result
				;;
			esac
            echo "      imagePullSecrets:" >> $result
        	echo "        - name: ocirsecret" >> $result
		fi
		count=$(($count+1))
	done
	count=$((0))
	docker login -u 'iddh4z5bswsv/jungeuno76@skuniv.ac.kr' -p 'bJTRNPbKu-[eK5NP>wV.' iad.ocir.io
	for i in $filenv; do
                if [ $i -eq 1 ]; then
                        case $count in
			0)	;;
			1)	cp ../nginxdockerfile ./
				cp ../nginx.conf ./	
				docker build -f ./nginxdockerfile -t ${usrname}frontimage:latest .
				rm ./nginxdockerfile
				rm nginx.conf
                docker tag ${usrname}frontimage:latest iad.ocir.io/iddh4z5bswsv/test:${usrname}frontimage
                docker push iad.ocir.io/iddh4z5bswsv/test:${usrname}frontimage
				;;
			11)	cp ../pydockerfile ./
				docker build -f ./pydockerfile -t ${usrname}backimage:latest .
				rm ./pydockerfile
                docker tag ${usrname}backimage:latest iad.ocir.io/iddh4z5bswsv/test:${usrname}backimage
                docker push iad.ocir.io/iddh4z5bswsv/test:${usrname}backimage
				;;
			esac
		fi
		count=$(($count+1))
	done
	cp ../nfs-pvc.yaml ./
    cp ../nfs-volume.yaml ./
    cp ../mysql.yaml ./
    sudo runuser -l opc -c 'kubectl apply -f /var/lib/jenkins/workspace/keepgo/nfs-pvc.yaml' 
	sudo runuser -l opc -c 'kubectl apply -f /var/lib/jenkins/workspace/keepgo/nfs-volume.yaml'
	sudo runuser -l opc -c 'kubectl apply -f /var/lib/jenkins/workspace/keepgo/mysql.yaml'
	sudo runuser -l opc -c 'kubectl apply -f /var/lib/jenkins/workspace/keepgo/baepo.yaml'
	rm nfs-pvc.yaml nfs-volume.yaml mysql.yaml
	docker rmi -f $(docker images -q)
fi

