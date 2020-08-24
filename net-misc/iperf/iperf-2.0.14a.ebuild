# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="https://sourceforge.net/projects/iperf2/"
SRC_URI="mirror://sourceforge/${PN}2/${PN}-2.0.13.tar.gz"

LICENSE="HPND"
SLOT="2"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="ipv6 threads debug"

DOCS="INSTALL README"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0.12-ipv6.patch
	"${FILESDIR}"/${P}.patch
)
S=${WORKDIR}/${PN}-2.0.13

src_configure() {
	econf \
		$(use_enable debug debuginfo) \
		$(use_enable ipv6) \
		$(use_enable threads)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	dodoc doc/*
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
