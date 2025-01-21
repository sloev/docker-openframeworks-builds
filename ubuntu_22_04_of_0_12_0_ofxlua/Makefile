build:
	podman build -t ofxdocker_2204_of_0_12_0 .
bash:
	podman run --rm -it    --entrypoint bash ofxdocker_2204_of_0_12_0

copy:
	podman create --name extract ofxdocker_2204_of_0_12_0
	podman cp extract:/of/apps/myApps/luaExample/bin ./artifacts
	podman rm extract