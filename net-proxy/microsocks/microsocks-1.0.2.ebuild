# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Multithreaded, small, efficient SOCKS5 server"
HOMEPAGE="https://github.com/rofl0r/microsocks"
SRC_URI="https://github.com/rofl0r/microsocks/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -r -e 's:/usr/local:/usr:' -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
