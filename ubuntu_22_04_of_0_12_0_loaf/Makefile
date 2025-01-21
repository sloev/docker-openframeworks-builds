build:
	podman build -t ofxdocker_2204_of_0_12_0_loaf .
bash:
	podman run --rm -it    --entrypoint bash ofxdocker_2204_of_0_12_0_loaf

copy:
	podman create --name extract ofxdocker_2204_of_0_12_0_loaf
	podman cp extract:/of/apps/myApps/loaf/bin ./artifacts
	podman rm extract