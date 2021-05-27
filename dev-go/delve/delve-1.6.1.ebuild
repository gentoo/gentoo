# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="A source-level debugger for the Go programming language"
HOMEPAGE="https://github.com/go-delve/delve"

EGO_PN="github.com/go-delve/delve"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT BSD BSD-2 Apache-2.0"
SLOT="0"
IUSE="test"

# Needs network access to download more unspecified modules.
RESTRICT="test"

src_compile() {
	go build -mod vendor -ldflags="-X main.Build=5dd4b7df9da1770edb4c2fd86535b58b1df294e7" -o "${S}/dlv" ./cmd/dlv || die
}

src_test() {
	go test
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobin dlv
}
