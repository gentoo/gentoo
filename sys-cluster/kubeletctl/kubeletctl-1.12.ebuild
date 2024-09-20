# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="A client for kubelet"
HOMEPAGE="https://github.com/cyberark/kubeletctl"
SRC_URI="https://github.com/cyberark/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT+=" test"

src_compile() {
	go build -ldflags "-s -w" || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
