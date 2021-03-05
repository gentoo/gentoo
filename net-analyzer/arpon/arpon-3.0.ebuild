# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="ArpON (Arp handler inspectiON) is a portable Arp handler"

MY_PN="ArpON"
MY_P="${MY_PN}-${PV}"
HOMEPAGE="http://arpon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-ng.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.0-CFLAGS.patch
	"${FILESDIR}"/${PN}-3.0-gentoo.patch
)
DOCS=( AUTHOR CHANGELOG README THANKS )
S="${WORKDIR}"/${MY_P}-ng

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/${PN}.initd-3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-3 ${PN}

	rm -r "${ED}"/var/{log,run} || die
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
}
