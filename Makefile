ifndef VERBOSE
.SILENT:
endif

GOPATH = $(shell go env GOPATH)
export GO111MODULE = auto

dep_repo = https://github.com/morrildl

dep_android = $(GOPATH)/src/playground/android
dep_log = $(GOPATH)/src/playground/log

LOG_DEP = printf "\033[1;36mDEP\033[0m "; echo
LOG_GOC = printf "\033[1;36mGOC\033[0m "; echo

##

all: apksign

apksign: main.go
	# Test for missing dependencies
	go vet 2>/dev/null || make -f $(MAKEFILE_LIST) deps
	 
	$(LOG_GOC) $@
	go build

deps: $(dep_android)/README.md \
	  $(dep_log)/README.md
	GOBIN=$$PWD go get ./...

$(dep_android)/README.md:
	$(LOG_DEP) Fetching dependency 'android'
	[ ! -d "$(dep_android)" ] && git clone $(dep_repo)/playground-android $(dep_android) || printf ""

$(dep_log)/README.md:
	$(LOG_DEP) Fetching dependency 'log'
	[ ! -d "$(dep_log)" ]     && git clone $(dep_repo)/playground-log     $(dep_log)     || printf ""
