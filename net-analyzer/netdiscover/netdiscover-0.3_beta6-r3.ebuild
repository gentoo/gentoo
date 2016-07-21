# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

DESCRIPTION="An active/passive address reconnaissance tool"
HOMEPAGE="http://nixgeneration.com/~jaime/netdiscover/"
LICENSE="GPL-2"
SRC_URI="
	http://nixgeneration.com/~jaime/${PN}/releases/${P/_/-}.tar.gz
	https://dev.gentoo.org/~jer/${P/_/-}-oui-db-update-20091010.patch.bz2
"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"

DEPEND="
	net-libs/libnet:1.1
	>=net-libs/libpcap-0.8.3-r1
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_/-}

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	epatch \
		"${WORKDIR}"/${P/_/-}-oui-db-update-20091010.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-misc.patch

	eautoreconf
}
