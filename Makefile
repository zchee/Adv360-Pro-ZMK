DOCKER := $(shell { command -v docker || command -v podman; })
TIMESTAMP := $(shell date -u +"%Y%m%d%H%M")
COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null)

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
		--mount type=bind,src=$(PWD)/firmware,target=/app/firmware \
		--mount type=bind,src=$(PWD)/config,target=/app/config,readonly \
		--env TIMESTAMP=$(TIMESTAMP) \
		--env COMMIT=$(COMMIT) \
		${CONTAINER_IMAGE}

clean:
	rm -f firmware/*.uf2
	$(DOCKER) image rm -f ${CONTAINER_IMAGE} docker.io/zmkfirmware/zmk-build-arm:stable
