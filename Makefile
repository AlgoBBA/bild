PKG = github.com/anthonynsimon/bild
BENCHMARK = BenchmarkRAWInput
VERSION ?= dev
LDFLAGS = -ldflags "-X $(PKG)/cmd.Version=$(VERSION) -extldflags \"-static\""
MAC_LDFLAGS = -ldflags "-X $(PKG)/cmd.Version=$(VERSION)"

release: release-x64 release-mac

release-bin:
	GOOS=linux GOARCH=amd64 go build -o bild $(LDFLAGS)

release-x64:
	GOOS=linux GOARCH=amd64 go build -o bild $(LDFLAGS) && tar -czf bild_$(VERSION)_x64.tar.gz bild && rm bild

release-x86:
	GOOS=linux GOARCH=386 go build -o bild $(LDFLAGS) && tar -czf bild_$(VERSION)_x86.tar.gz bild && rm bild

release-mac:
	go build $(MAC_LDFLAGS) -o bild && tar -czf bild_$(VERSION)_mac.tar.gz bild && rm bild

install:
	go install $(MAC_LDFLAGS)

lint:
	golint $(PKG)

race:
	go test ./... -v -race -timeout 15s

test:
	go test ./... -timeout 60s $(LDFLAGS) -v

cover:
	go test ./... -race -v -timeout 15s -coverprofile=coverage.out
	go tool cover -html=coverage.out

fmt:
	go fmt ./...

bench:
	go test ./... $(LDFLAGS) -v -run NOT_EXISTING -bench $(BENCHMARK) -benchtime 5s
