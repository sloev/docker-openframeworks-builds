build:
	podman build -t ofxdocker .
bash:
	podman run --rm -it    --entrypoint bash ofxdocker