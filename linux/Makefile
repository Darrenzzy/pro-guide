# 获取当前项目名称
PROJECT_NAME := $(notdir $(shell pwd))
VERSION := "1.0.0"
GO_FILES := $(shell find . -name "*.go" | grep -v vendor | grep -v _test.go)
COUNT := $(shell git rev-list HEAD | wc -l | sed -e 's/ *//g' | xargs -n1 printf %04d)
BRANCH := $(shell git rev-parse --symbolic-full-name --abbrev-ref HEAD)
COMMIT := $(shell git show --abbrev-commit HEAD | grep '^commit' | sed -e 's/commit //')
BLDDIR := build
# pb目录 
APIDIR := "/Users/darren/go/src/vendor/yourpbdir/${PROJECT_NAME}/pb"
BLDFLAGS := -ldflags="-s -w -X main.ProjectName=${PROJECT_NAME} -X main.Version=${VERSION} -X main.Built=${BRANCH}.${COMMIT}.${COUNT}"
EXT=
ifeq (${GOOS},windows)
    EXT=.exe
endif

all: build

pb:
	@cd ${APIDIR} && protoc --go_out=plugins=irpc:. *.proto

dep:
	@go get -v -d ./...

build: pb dep
	@mkdir -p ${BLDDIR}
	@go build $(BLDFLAGS) -o ${BLDDIR}/${PROJECT_NAME}${EXT} ./main.go

linux: pb dep
	@mkdir -p ${BLDDIR}

	echo $(BLDFLAGS)
	@env GOOS=linux GOARCH=amd64 go build $(BLDFLAGS) -o ${BLDDIR}/${PROJECT_NAME}${EXT} ./main.go


install: linux
	@cp ${PROJECT_NAME}.json build
	@docker run -d --name ${PROJECT_NAME} \
	-v ${CURDIR}/build/${PROJECT_NAME}:/${PROJECT_NAME} \
	-v ${CURDIR}/build/${PROJECT_NAME}.json:/${PROJECT_NAME}.json \
	--network gateway-internal-ice centos /${PROJECT_NAME}

clean:
	@rm -rf ${BLDDIR}/* .cover

.PHONY: dep lint race coverage coverage_html test build clean
