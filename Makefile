DOCKER := $(shell { command -v docker || command -v podman; })
TIMESTAMP := $(shell date -u +"%Y%m%d%H%M")
COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null)
detected_OS := $(shell uname)  # Classify UNIX OS
ifeq ($(strip $(detected_OS)),Darwin) #We only care if it's OS X
	SELINUX1 :=
	SELINUX2 :=
else
	SELINUX1 := :z
	SELINUX2 := ,z
endif

CONTAINER_IMAGE = zmk:latest
DOCKER_FLAGS = --rm --pull -f Dockerfile -t ${CONTAINER_IMAGE}
DOCKER_NOCACHE =
ifneq (${DOCKER_NOCACHE},)
	DOCKER_FLAGS += --no-cache
endif

.PHONY: all build compile clean

all: build compile

build:
	$(shell bin/get_version.sh >> /dev/null)
	$(DOCKER) image build ${DOCKER_FLAGS} .

compile:
	$(DOCKER) container run --rm -it --name zmk \
		--mount type=bind,src=$(PWD)/firmware,dst=/app/firmware$(SELINUX1) \
		--mount type=bind,src=$(PWD)/config,dst=/app/config:ro$(SELINUX2) \
		--env TIMESTAMP=$(TIMESTAMP) \
		--env COMMIT=$(COMMIT) \
		${CONTAINER_IMAGE}

clean:
	rm -f firmware/*.uf2
	$(DOCKER) image rm -f ${CONTAINER_IMAGE} docker.io/zmkfirmware/zmk-build-arm:stable
