# Copyright 1999-2025 Gentoo Authors
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

	# disable failing tests, require network
	rm cmd/dlv/dlv_test.go || die
	sed -e 's/TestGuessSubstitutePath/_&/' -i service/test/integration2_test.go || die
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

pkg_postinst() {
	elog "Telemetry notice:"
	elog "Starting with version 1.24.0, Delve will begin collecting opt-in telemetry"
	elog "data using the same mechanism used by the Go toolchain."
	elog
	elog "For more information, please see:"
	elog "  * https://github.com/golang/go/issues/68384"
	elog "  * https://go.dev/doc/telemetry#background"
	elog "  * https://github.com/go-delve/delve/issues/3815"
}
