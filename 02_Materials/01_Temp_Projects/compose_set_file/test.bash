ENVFILE="./env.txt"
USRFILE="./username.txt"
result=pods_set.yaml
while IFS= read -r line; do
	usrname="${line%%@*}"
	echo "$usrname"
done < "$USRFILE"
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
	echo "    matadata:" >> $result
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
				echo "          image: ${username}frontimage:latest" >> $result
				echo "          pots:" >> $result
				echo "            - containerPort: 80" >> $result
				;;
			2) 	echo bootstrap
				mkdir frontend && mv ./*.html ./frontend && mv ./*.css ./frontend && mv ./*.js ./frontend
				;;
			7)	echo mysql
				;;
			11)	echo python
				mkdir backend && mv *.py backend/
				echo "        - name: backend" >> $result
				echo "          image: {$usrname}backimage:latest" >> $result
				echo "          ports:" >> $result
				echo "          - containerPort: 8080" >> $result

				;;

			esac
		fi
		count=$(($count+1))
	done
	count=$((0))
	for i in $filenv; do
                if [ $i -eq 1 ]; then
                        case $count in
			0)	;;
			1)	cp ../nginxdockerfile ./
				cp ../nginx.conf ./	
				docker build -f ./nginxdockerfile -t ${usrname}frontimge:latest .
				rm ./nginxdockerfile
				rm nginx.conf
				;;
			11)	cp ../pydockerfile ./
				docker build -f ./pydockerfile -t ${usrname}backimage:latest .
				rm ./pydockerfile 
				;;
			esac
		fi
		count=$(($count+1))
	done
fi

