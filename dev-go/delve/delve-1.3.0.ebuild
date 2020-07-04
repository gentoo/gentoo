# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module
EGO_PN="github.com/go-delve/delve"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A source-level debugger for the Go programming language"
HOMEPAGE="https://github.com/go-delve/delve"

LICENSE="MIT BSD BSD-2 Apache-2.0"
SLOT="0"

RESTRICT="test"

src_compile() {
	go build -ldflags="-X main.Build=${a3e884e}" -o "${S}/dlv" ./cmd/dlv || die
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobin dlv
}
