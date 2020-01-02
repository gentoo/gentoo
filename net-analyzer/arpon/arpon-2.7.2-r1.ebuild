# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="ArpON (Arp handler inspectiON) is a portable Arp handler"

MY_PN="ArpON"
MY_P="${MY_PN}-${PV}"
HOMEPAGE="http://arpon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.7.2-CFLAGS.patch
	"${FILESDIR}"/${PN}-2.7.2-etc.patch
)
DOCS=( AUTHOR CHANGELOG )
S="${WORKDIR}"/${MY_P}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
