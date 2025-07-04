# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Like inetd, but for WebSockets"
HOMEPAGE="https://github.com/joewalnes/websocketd"
SRC_URI="
	https://github.com/joewalnes/websocketd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	CGO_ENABLED=0 ego build -o ${PN}
}

src_test() {
	ego test -work "./..."
}

src_install() {
	dobin ${PN}
	dodoc CHANGES README.md
	newman release/${PN}.man ${PN}.1
}
