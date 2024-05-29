#!/bin/bash
CPU_ARCH=cortex-a55
export ANDROID_NDK_HOME=${ANDROID_NDK_LATEST_HOME}
export CGO_ENABLED=0
export GOEXPERIMENT=newinliner
export CGO_CFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"
export CGO_CXXFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"
export CGO_LDFLAGS="-w -Ofast -mcpu=${CPU_ARCH} -mtune=${CPU_ARCH} -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -fuse-ld=lld -s -Wl,-O2,--as-needed,--gc-sections,--icf=all -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce"

go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init
go mod tidy
gomobile bind -target=android/arm64 -androidapi=21 -trimpath -gcflags=all="-B" -ldflags="-X github.com/xtls/xray-core/core.build=$(git rev-parse HEAD) -s -w -stripfn 2 -buildid=" ./
