#!/bin/bash
XCFLAGS="-Wno-unused-command-line-argument -mcpu=cortex-a55+crypto+ssbs -mtune=cortex-a55 -Ofast -flto=full -fno-common -fno-plt -fno-semantic-interposition -fcf-protection=none -mllvm -polly -mllvm -polly-vectorizer=stripmine -mllvm -polly-ast-use-context -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce -fuse-ld=lld -s -Wl,-O3,--as-needed,--gc-sections,--icf=all,-z,lazy,-z,norelro,-sort-common"
export CGO_CFLAGS="$XCFLAGS"
export CGO_CXXFLAGS="$XCFLAGS"
export CGO_LDFLAGS="$XCFLAGS"
export CGO_ENABLED=0
export GOEXPERIMENT=newinliner
export GOARM64=v8.2,lse,crypto

go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init
go mod tidy
gomobile bind -target=android/arm64 -androidapi=21 -trimpath -gcflags=all="-B" -ldflags="-s -w -buildid=" ./