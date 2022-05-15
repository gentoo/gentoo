# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://github.com/joewalnes/websocketd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
DESCRIPTION="Like inetd, but for WebSockets"
HOMEPAGE="https://github.com/joewalnes/websocketd"
SLOT="0"
LICENSE="BSD-2"
SRC_URI="
	${ARCHIVE_URI}
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz
"

src_compile() {
	GOBIN="${S}/bin" CGO_ENABLED=0 go install ./... || die
}

src_test() {
	go test -work "./..." || die
}

src_install() {
	dobin bin/${PN}
	dodoc CHANGES README.md
}
