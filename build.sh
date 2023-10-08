#!/bin/bash
GO_VERSION=1.21.2
NDK_VERSION=r26
CPU_ARCH=cortex-a55
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NDK_HOME=/opt/android-sdk/ndk/${NDK_VERSION}
export CGO_ENABLED=0
COMPILER_FLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"
export CGO_CFLAGS=${COMPILER_FLAGS}
export CGO_CXXFLAGS=${COMPILER_FLAGS}
export CGO_LDFLAGS=${COMPILER_FLAGS}

sudo apt install -y sdkmanager wget
wget -O /tmp/go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
tar -C ~ -xzf /tmp/go.tar.gz
rm -f /tmp/go.tar.gz
export PATH=$(realpath ~/go/bin):$PATH
sdkmanager "platforms;android-33"
mkdir -p ${ANDROID_HOME}/ndk
pushd ${ANDROID_HOME}/ndk
wget "https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux.zip"
unzip -q android-ndk-${NDK_VERSION}-linux.zip
rm -f android-ndk-${NDK_VERSION}-linux.zip
mv android-ndk-${NDK_VERSION} ${NDK_VERSION}
popd
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init
go mod tidy
gomobile bind -target=android/arm64 -androidapi=21 -trimpath -ldflags "-X 'github.com/xtls/xray-core/core.build=$(git rev-parse HEAD)' -s -w -buildid=" ./
