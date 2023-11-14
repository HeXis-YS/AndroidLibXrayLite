#!/bin/bash
GO_VERSION=1.21.4
NDK_VERSION=r26b
CPU_ARCH=cortex-a55
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NDK_HOME=/opt/android-sdk/ndk/android-ndk-${NDK_VERSION}
export CGO_ENABLED=0
export CGO_CFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"
export CGO_CXXFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"
export CGO_LDFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"

sudo apt install -y sdkmanager wget unzip
wget -O /tmp/go.tar.xz https://github.com/HeXis-YS/go/releases/download/go${GO_VERSION}/go${GO_VERSION}.linux-amd64.tar.xz
tar -C ~ -xf /tmp/go.tar.xz
rm -f /tmp/go.tar.xz
export PATH=$(realpath ~/go/bin):$PATH
sdkmanager "platforms;android-33"
mkdir -p ${ANDROID_SDK_ROOT}/ndk
wget -O /tmp/ndk.zip https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux.zip
unzip -d ${ANDROID_SDK_ROOT}/ndk /tmp/ndk.zip
rm -f /tmp/ndk.zip
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init
go mod tidy
gomobile bind -target=android/arm64 -androidapi=21 -trimpath -gcflags=all="-B" -ldflags=all="-X github.com/xtls/xray-core/core.build=$(git rev-parse HEAD) -s -w -stripfn 2 -buildid=" ./
