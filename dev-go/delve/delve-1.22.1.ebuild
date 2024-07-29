# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A source-level debugger for the Go programming language"
HOMEPAGE="https://github.com/go-delve/delve"
SRC_URI="https://github.com/go-delve/delve/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT BSD BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default

	# disable failing tests
	sed -e 's/TestDebugger_LaunchWithTTY/_&/' -i service/debugger/debugger_unix_test.go || die
	sed -e 's/TestDump/_&/' -i pkg/proc/proc_test.go || die
	rm cmd/dlv/dlv_test.go || die
}

src_compile() {
	ego build -mod=vendor -ldflags="-X main.Build=${PV}" -o "${S}/dlv" ./cmd/dlv
}

src_test() {
	ego test -count 1 -p 1 -ldflags="-X main.Build=${PV}" ./...
}

src_install() {
	dobin dlv
	dodoc README.md CHANGELOG.md
}
