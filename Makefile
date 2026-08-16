# SNI-Spoofing-Go — build targets
# CLI: CGO_ENABLED=0. GUI: Wails v2.
LDFLAGS := -s -w
CGO_ENABLED := 0
DIST ?= dist
BUILD_DIR ?= .build
DEV_BIN := $(BUILD_DIR)/sni-spoofing
GO ?= go
GOPATH := $(shell $(GO) env GOPATH)
WAILS := $(GOPATH)/bin/wails
WAILS_VERSION := v2.12.0
GUI_DIR := gui
GUI_WAILS_OUT := $(GUI_DIR)/build/bin
WAILS_FLAGS := -trimpath -clean
WAILS_LINUX_TAGS := -tags webkit2_41
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_S),Linux)
WAILS_NATIVE_EXTRA := $(WAILS_LINUX_TAGS)
endif

CLI_ASSET_WINDOWS_AMD64 := $(DIST)/sni-spoofing-windows-amd64.exe
CLI_ASSET_WINDOWS_ARM64 := $(DIST)/sni-spoofing-windows-arm64.exe
CLI_ASSET_LINUX_AMD64 := $(DIST)/sni-spoofing-linux-amd64
CLI_ASSET_LINUX_ARM64 := $(DIST)/sni-spoofing-linux-arm64
CLI_ASSET_LINUX_ARMV7 := $(DIST)/sni-spoofing-linux-armv7
CLI_ASSET_LINUX_ARM := $(DIST)/sni-spoofing-linux-arm
CLI_ASSET_LINUX_ARM_XSCALE := $(DIST)/sni-spoofing-linux-arm_xscale
CLI_ASSET_LINUX_MIPSLE := $(DIST)/sni-spoofing-linux-mipsle
CLI_ASSET_LINUX_MIPS := $(DIST)/sni-spoofing-linux-mips
CLI_ASSET_DARWIN_AMD64 := $(DIST)/sni-spoofing-darwin-amd64
CLI_ASSET_DARWIN_ARM64 := $(DIST)/sni-spoofing-darwin-arm64
GUI_ASSET_LINUX_AMD64 := $(DIST)/sni-spoofing-gui-linux-amd64
GUI_ASSET_LINUX_ARM64 := $(DIST)/sni-spoofing-gui-linux-arm64
GUI_ASSET_WINDOWS_AMD64 := $(DIST)/sni-spoofing-gui-windows-amd64.exe
GUI_ASSET_WINDOWS_ARM64 := $(DIST)/sni-spoofing-gui-windows-arm64.exe
GUI_ASSET_DARWIN := $(DIST)/sni-spoofing-gui-darwin-universal.zip

.PHONY: dist all build windows-amd64 windows-arm64 linux-amd64 linux-arm64 linux-armv7 linux-arm linux-arm_xscale linux-mipsle linux-mips darwin-amd64 darwin-arm64 test mod install-wails deps-linux gui-frontend gui gui-windows-amd64 gui-windows-arm64 gui-linux-amd64 gui-linux-arm64 gui-darwin-universal gui-dist clean

build:
	@mkdir -p $(BUILD_DIR)
	CGO_ENABLED=$(CGO_ENABLED) go build -ldflags "$(LDFLAGS)" -o $(DEV_BIN) .
mod:
	go mod download
test:
	CGO_ENABLED=$(CGO_ENABLED) go test ./...
install-wails:
	go install github.com/wailsapp/wails/v2/cmd/wails@$(WAILS_VERSION)
deps-linux:
	sudo apt-get update
	sudo apt-get install -y libgtk-3-dev libwebkit2gtk-4.1-dev

gui-frontend: install-wails
	cd $(GUI_DIR)/frontend && npm ci

gui-windows-amd64: gui-frontend
	@mkdir -p $(DIST)
	cd $(GUI_DIR) && $(WAILS) build -platform windows/amd64 $(WAILS_FLAGS)
	cp $(GUI_WAILS_OUT)/sni-spoofing-gui.exe $(GUI_ASSET_WINDOWS_AMD64)

gui-windows-arm64: gui-frontend
	@mkdir -p $(DIST)
	cd $(GUI_DIR) && $(WAILS) build -platform windows/arm64 $(WAILS_FLAGS)
	cp $(GUI_WAILS_OUT)/sni-spoofing-gui.exe $(GUI_ASSET_WINDOWS_ARM64)

gui-linux-amd64: gui-frontend
	@mkdir -p $(DIST)
	cd $(GUI_DIR) && $(WAILS) build -platform linux/amd64 $(WAILS_FLAGS) $(WAILS_LINUX_TAGS)
	cp $(GUI_WAILS_OUT)/sni-spoofing-gui $(GUI_ASSET_LINUX_AMD64)

gui-linux-arm64: gui-frontend
	@mkdir -p $(DIST)
	cd $(GUI_DIR) && $(WAILS) build -platform linux/arm64 $(WAILS_FLAGS) $(WAILS_LINUX_TAGS)
	cp $(GUI_WAILS_OUT)/sni-spoofing-gui $(GUI_ASSET_LINUX_ARM64)

gui-darwin-universal: gui-frontend
	@mkdir -p $(DIST)
	cd $(GUI_DIR) && $(WAILS) build -platform darwin/universal $(WAILS_FLAGS)
	cd $(GUI_WAILS_OUT) && zip -r "$(CURDIR)/$(GUI_ASSET_DARWIN)" sni-spoofing-gui.app

gui-dist: gui-windows-amd64 gui-windows-arm64 gui-linux-amd64 gui-linux-arm64

windows-amd64:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-windows-amd64.exe .
windows-arm64:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-windows-arm64.exe .
linux-amd64:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-amd64 .
linux-arm64:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-arm64 .
linux-armv7:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-armv7 .
linux-arm:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-arm .
linux-arm_xscale:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=5 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-arm_xscale .
linux-mipsle:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=mipsle GOMIPS=softfloat go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-mipsle .
linux-mips:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=mips GOMIPS=softfloat go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-linux-mips .
darwin-amd64:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-darwin-amd64 .
darwin-arm64:
	@mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -ldflags "$(LDFLAGS)" -o $(DIST)/sni-spoofing-darwin-arm64 .

dist all: windows-amd64 windows-arm64 linux-amd64 linux-arm64 linux-armv7 linux-arm linux-arm_xscale linux-mipsle linux-mips darwin-amd64 darwin-arm64
	@ls -lh $(DIST)/

gui: gui-windows-amd64 gui-windows-arm64
clean:
	rm -rf $(BUILD_DIR) $(GUI_WAILS_OUT)
	rm -f $(DIST)/sni-spoofing* $(DIST)/SHA256SUMS
