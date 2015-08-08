# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit cmake-utils readme.gentoo

DESCRIPTION="ArpON (Arp handler inspectiON) is a portable Arp handler"

MY_PN="ArpON"
MY_P="${MY_PN}-${PV}"
HOMEPAGE="http://arpon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/libdnet
	net-libs/libnet:1.1
	net-libs/libpcap"

RDEPEND=${DEPEND}

S="${WORKDIR}"/${MY_P}

src_prepare() {
	sed -i -e "/set(CMAKE_C_FLAGS/d" CMakeLists.txt || die

	DOC_CONTENTS="${PN} now installs an init script. Please edit
		the /etc/conf.d/arpon file to match your needs"
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	readme.gentoo_create_doc
}
