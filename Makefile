# Copyright The gittuf Authors
# SPDX-License-Identifier: Apache-2.0

GIT_VERSION ?= $(shell git describe --tags --always --dirty)

LDFLAGS=-buildid= -X github.com/gittuf/git-remote-gittuf/.gitVersion=$(GIT_VERSION)

.PHONY : build test install fmt

default : install

build : test
ifeq ($(OS),Windows_NT)
	set CGO_ENABLED=0
	go build -trimpath -ldflags "$(LDFLAGS)" -o dist/git-remote-gittuf .
	set CGO_ENABLED=
else
	CGO_ENABLED=0 go build -trimpath -ldflags "$(LDFLAGS)" -o dist/git-remote-gittuf .
endif

install : test just-install

just-install :
ifeq ($(OS),Windows_NT)
	set CGO_ENABLED=0
	go install -trimpath -ldflags "$(LDFLAGS)" github.com/gittuf/git-remote-gittuf
	set CGO_ENABLED=
else
	CGO_ENABLED=0 go install -trimpath -ldflags "$(LDFLAGS)" github.com/gittuf/git-remote-gittuf
endif

test :
	go test -race -timeout 20m -v ./...

fmt :
	go fmt ./...
