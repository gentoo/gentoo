# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
GIT_COMMIT=27d895fb207c9367a2d516f739578bbcb5db0368

DESCRIPTION="A client for kubelet"
HOMEPAGE="https://github.com/cyberark/kubeletctl"
SRC_URI="https://github.com/cyberark/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT+=" test"

src_compile() {
	go build -ldflags "-s -w" || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
