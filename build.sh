#!/bin/bash
GO_VERSION=1.21.1
NDK_VERSION=r26
CPU_ARCH=cortex-a55
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NDK_HOME=/opt/android-sdk/ndk/${NDK_VERSION}
export CGO_ENABLED=0
export CGO_CFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fuse-ld=lld -Wl,--gc-sections -Wl,--icf=all"
export CGO_CXXFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fuse-ld=lld -Wl,--gc-sections -Wl,--icf=all"
export CGO_LDFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fuse-ld=lld -Wl,--gc-sections -Wl,--icf=all"

sudo apt install -y sdkmanager wget
wget -O /tmp/go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
tar -C ~ -xzf /tmp/go.tar.gz
rm -f /tmp/go.tar.gz
export PATH=$(realpath ~/go/bin):$PATH
sdkmanager "ndk;${NDK_VERSION}" "platforms;android-33"
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init
go mod tidy
gomobile bind -target=android/arm64 -androidapi=21 -trimpath -ldflags "-X 'github.com/xtls/xray-core/core.build=$(git rev-parse HEAD)' -s -w -buildid=" ./
