ENVFILE="./env.txt"
USRFILE="./username.txt"
front=frontend.yaml
back=backend.yaml
db=db.yaml
usrname=""
if [ -e "$USRFILE" ]; then
	usrname=$(cat $USRFILE)
    content=$(cat $USRFILE)
    username=${content%%-*}
    servicename=${content##*-}
    cd $username
    cd $servicename
    cd $servicename
fi
echo $usrname
echo $username
echo $servicename
ls
if [ -e "$ENVFILE" ]; then
    sudo runuser -l opc -c "ssh -i /home/opc/ssh-key.key opc@nfs-server-ip mkdir -p /nfs-share/${usrname}"
	touch $front
    touch $back
    touch $db
	filenv=$(cat "$ENVFILE" | grep -o .)
	count=0
	for i in $filenv; do
		if [ $i -eq 1 ]; then
			case $count in
			0) 	echo apache
				;;
			1) 	echo nginx
                echo "apiVersion: apps/v1" > $front
                echo "kind: Deployment" >> $front
                echo "metadata:" >> $front
                echo "  name: frontend-deployment" >> $front
                echo "spec:" >> $front
                echo "  selector:" >> $front
                echo "    matchLabels:" >> $front
                echo "      app: front" >> $front
                echo "  replicas: 2" >> $front
                echo "  template:" >> $front
                echo "    metadata:" >> $front
                echo "      labels:" >> $front
                echo "        app: front" >> $front
                echo "    spec:" >> $front
                echo "      affinity:" >> $front
                echo "        podAntiAffinity:" >> $front
                echo "          requiredDuringSchedulingIgnoredDuringExecution:" >> $front
                echo "            - labelSelector:" >> $front
                echo "                matchExpressions:" >> $front
                echo "                  - key: app" >> $front
                echo "                    operator: In" >> $front
                echo "                    values:" >> $front
                echo "                      - front" >> $front
                echo "              topologyKey: \"kubernetes.io/hostname\"" >> $front
                echo "      containers:" >> $front
                echo "        - name: frontend" >> $front
                echo "          image: iad.ocir.io/tenancynamespace/test:${usrname}frontimage" >> $front
                echo "          ports:" >> $front
                echo "            - containerPort: 80" >> $front
                echo "      imagePullSecrets:" >> $front
                echo "        - name: ocirsecret" >> $front
                echo "---" >> $front
                echo "apiVersion: v1" >> $front
                echo "kind: Service" >> $front
                echo "metadata:" >> $front
                echo "  name: front-service" >> $front
                echo "spec:" >> $front
                echo "  type: LoadBalancer" >> $front
                echo "  ports:" >> $front
                echo "    - port: 80" >> $front
                echo "      protocol: TCP" >> $front
                echo "      targetPort: 80" >> $front
                echo "  selector:" >> $front
                echo "    app: front" >> $front
				;;
			2) 	echo bootstrap
            	
				;;
            7)	echo python
                echo "apiVersion: apps/v1" > $back
                echo "kind: Deployment" >> $back
                echo "metadata:" >> $back
                echo "  name: backend-deployment" >> $back
                echo "spec:" >> $back
                echo "  selector:" >> $back
                echo "    matchLabels:" >> $back
                echo "      app: back" >> $back
                echo "  replicas: 2" >> $back
                echo "  template:" >> $back
                echo "    metadata:" >> $back
                echo "      labels:" >> $back
                echo "        app: back" >> $back
                echo "    spec:" >> $back
                echo "      affinity:" >> $back
                echo "        podAntiAffinity:" >> $back
                echo "          requiredDuringSchedulingIgnoredDuringExecution:" >> $back
                echo "            - labelSelector:" >> $back
                echo "                matchExpressions:" >> $back
                echo "                  - key: app" >> $back
                echo "                    operator: In" >> $back
                echo "                    values:" >> $back
                echo "                      - back" >> $back
                echo "              topologyKey: \"kubernetes.io/hostname\"" >> $back
                echo "      containers:" >> $back
                echo "        - name: backend" >> $back
                echo "          image: iad.ocir.io/tenancynamespace/test:${usrname}backimage" >> $back
                echo "          ports:" >> $back
                echo "            - containerPort: 5000" >> $back
                echo "      imagePullSecrets:" >> $back
                echo "        - name: ocirsecret" >> $back
                echo "---" >> $back
                echo "apiVersion: v1" >> $back
                echo "kind: Service" >> $back
                echo "metadata:" >> $back
                echo "  name: api" >> $back
                echo "spec:" >> $back
                echo "  type: LoadBalancer" >> $back
                echo "  ports:" >> $back
                echo "    - port: 5000" >> $back
                echo "      protocol: TCP" >> $back
                echo "      targetPort: 5000" >> $back
                echo "  selector:" >> $back
                echo "    app: back" >> $back
				;;
			11)	echo mongodb
            	echo "apiVersion: v1" > $db
                echo "kind: PersistentVolume" >> $db
                echo "metadata:" >> $db
                echo "  name: ${usrname}-pv" >> $db
                echo "  labels:" >> $db
                echo "    volume: ${usrname}-pv" >> $db
                echo "spec:" >> $db
                echo "  capacity:" >> $db
                echo "    storage: 1Gi" >> $db
                echo "  volumeMode: Filesystem" >> $db
                echo "  accessModes:" >> $db
                echo "    - ReadWriteMany" >> $db
                echo "  persistentVolumeReclaimPolicy: Retain " >> $db
                echo "  storageClassName: \"\" " >> $db
                echo "  nfs:" >> $db
                echo "    path: /nfs-share/${usrname}" >> $db
                echo "    server: nfs-server-ip" >> $db
                echo "---" >> $db
                echo "apiVersion: v1" >> $db
                echo "kind: PersistentVolumeClaim" >> $db
                echo "metadata:" >> $db
                echo "  name: ${usrname}-pvc" >> $db
                echo "spec:" >> $db
                echo "  selector:" >> $db
                echo "    matchLabels:" >> $db
                echo "      volume: ${usrname}-pv" >> $db
                echo "  accessModes:" >> $db
                echo "  - ReadWriteMany" >> $db
                echo "  resources:" >> $db
                echo "    requests:" >> $db
                echo "      storage: 1Gi" >> $db
                echo "  storageClassName: \"\" " >> $db
                echo "---" >> $db
                echo "apiVersion: apps/v1" >> $db
                echo "kind: Deployment" >> $db
                echo "metadata:" >> $db
                echo "  name: db-deployment" >> $db
                echo "  labels:" >> $db
                echo "    app: db-deployment" >> $db
                echo "spec:" >> $db
                echo "  replicas: 1" >> $db
                echo "  selector:" >> $db
                echo "    matchLabels:" >> $db
                echo "      app: db" >> $db
                echo "  template:" >> $db
                echo "    metadata:" >> $db
                echo "      name: db" >> $db
                echo "      labels:" >> $db
                echo "        app: db" >> $db
                echo "    spec:" >> $db
                echo "      containers:" >> $db
                echo "        - name: mongodb-container" >> $db
                echo "          image: iad.ocir.io/tenancynamespace/test:${usrname}dbimage" >> $db
                echo "          env: " >> $db
                echo "            - name: MONGO_INITDB_DATABASE" >> $db
                echo "              value: database" >> $db
                echo "          ports:" >> $db
                echo "            - containerPort: 27017" >> $db
                echo "          volumeMounts:" >> $db
                echo "            - name: ${usrname}-pv" >> $db
                echo "              mountPath: /data/db" >> $db
                echo "              readOnly: false" >> $db
                echo "      volumes:" >> $db
                echo "        - name: ${usrname}-pv" >> $db
                echo "          persistentVolumeClaim:" >> $db
                echo "            claimName: ${usrname}-pvc" >> $db
                echo "---" >> $db
                echo "apiVersion: v1" >> $db
                echo "kind: Service" >> $db
                echo "metadata:" >> $db
                echo "  name: db-service" >> $db
                echo "  labels:" >> $db
                echo "    app: db-service" >> $db
                echo "spec:" >> $db
                echo "  type: LoadBalancer" >> $db
                echo "  ports:" >> $db
                echo "    - protocol: TCP" >> $db
                echo "      port: 27017" >> $db
                echo "      targetPort: 27017" >> $db
                echo "  selector:" >> $db
                echo "    app: db" >> $db
                
				;;
			
			esac
		fi
		count=$(($count+1))
	done

	count=$((15))
	docker login -u 'tenancynamespace/username' -p 'apitoken' iad.ocir.io
    sudo runuser -l opc -c "kubectl create namespace ${usrname}"
    reversed=""
    for (( i = ${#filenv} - 1; i >= 0; i-- )); do
      char="${filenv:$i:1}"
      reversed="$reversed$char"
    done
	for i in $reversed; do
		if [ $i -eq 1 ]; then
			case $count in
			1)	echo frontrun
            	docker build -f ./frontend/Dockerfile -t ${usrname}frontimage:latest ./frontend
                docker tag ${usrname}frontimage:latest iad.ocir.io/tenancynamespace/test:${usrname}frontimage
                docker push iad.ocir.io/tenancynamespace/test:${usrname}frontimage
                sudo runuser -l opc -c "kubectl apply -f /var/lib/jenkins/workspace/keepgo/${username}/${servicename}/${servicename}/frontend.yaml -n ${usrname}"
				;;
			7)	echo backrun
            	docker build -f ./backend/Dockerfile -t ${usrname}backimage:latest ./backend
                docker tag ${usrname}backimage:latest iad.ocir.io/tenancynamespace/test:${usrname}backimage
                docker push iad.ocir.io/tenancynamespace/test:${usrname}backimage
                sudo runuser -l opc -c "kubectl apply -f /var/lib/jenkins/workspace/keepgo/${username}/${servicename}/${servicename}/backend.yaml -n ${usrname}"
				;;
			11)	echo dbrun
            	docker build -f ./db/Dockerfile -t ${usrname}dbimage:latest ./db
                docker tag ${usrname}dbimage:latest iad.ocir.io/tenancynamespace/test:${usrname}dbimage
                docker push iad.ocir.io/tenancynamespace/test:${usrname}dbimage
                sudo runuser -l opc -c "kubectl apply -f /var/lib/jenkins/workspace/keepgo/${username}/${servicename}/${servicename}/db.yaml -n ${usrname}"
             	;;
			esac
		fi
		count=$(($count-1))
	done
	rm backend.yaml frontend.yaml db.yaml
	docker rmi -f $(docker images -q)
fi