ifndef VERBOSE
.SILENT:
endif

GOPATH = $(shell go env GOPATH)
export GO111MODULE = auto

dep_repo = https://github.com/morrildl

APKSIGN_DEP_ANDROID = $(GOPATH)/src/playground/android
APKSIGN_DEP_LOG = $(GOPATH)/src/playground/log

LOG_APKSIGN = printf "[\033[1;36mapksign\033[0m] "; echo

##

all: $(out)/bin/apksign

composition-targets += $(out)/bin/apksign

$(out)/bin/apksign: src/apksign/main.go
	# Test for missing go dependencies
	(cd src/apksign && go vet 2>/dev/null) || make -f $(MAKEFILE_LIST) deps
	 
	$(LOG_APKSIGN) -n GOC $$(basename $@)...
	cd src/apksign && GOBIN=$$PWD go get ./...
	mv src/apksign/apksign $@
	printf "$(green)done$(generic)\n"

deps: $(APKSIGN_DEP_ANDROID)/README.md \
	  $(APKSIGN_DEP_LOG)/README.md

$(APKSIGN_DEP_ANDROID)/README.md:
	$(LOG_APKSIGN) Fetching dependency 'android'
	[ ! -d "$(APKSIGN_DEP_ANDROID)" ] && git clone $(dep_repo)/playground-android $(APKSIGN_DEP_ANDROID) || printf ""

$(APKSIGN_DEP_LOG)/README.md:
	$(LOG_APKSIGN) Fetching dependency 'log'
	[ ! -d "$(APKSIGN_DEP_LOG)" ]     && git clone $(dep_repo)/playground-log     $(APKSIGN_DEP_LOG)     || printf ""
