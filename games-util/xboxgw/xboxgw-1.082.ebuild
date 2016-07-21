# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

XBOXGW_P="${PN}-1.08-2"
HMLIBS_P="hmlibs-1.07-2"

DESCRIPTION="Tunnels XBox system link games over the net"
HOMEPAGE="http://www.xboxgw.com/"
SRC_URI="http://www.xboxgw.com/rel/dist2.1/tarballs/i386/${XBOXGW_P}.tgz
	http://www.xboxgw.com/rel/dist2.1/tarballs/i386/${HMLIBS_P}.i386.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

QA_PREBUILT="opt/${PN}/lib/libhmdb.so
	opt/${PN}/lib/libhmsched.so
	opt/${PN}/lib/libhmcli.so
	opt/${PN}/lib/libhmsdb.so
	opt/${PN}/bin/hmdbdump
	opt/${PN}/bin/xboxgw
	opt/${PN}/bin/xbifsetup"

S=${WORKDIR}

src_install() {
	into /opt/${PN}

	cd "${WORKDIR}/${HMLIBS_P}"
	dolib.so *.so
	dobin hmdbdump
	insinto /usr/include/hmlibs
	doins *.h

	cd "${WORKDIR}/${XBOXGW_P}"
	dobin xboxgw xbifsetup
	dodoc *.txt

	if use amd64 ; then
		mv "${D}"/opt/${PN}/lib64 "${D}"/opt/${PN}/lib || die
	fi
}
