# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils flag-o-matic versionator

TT_DEB_MAJOR=$(get_version_component_range 4)
TT_DEB_MAJOR=${TT_DEB_MAJOR/p}
TT_DEB_MINOR=$(get_version_component_range 5)
TT_DEB_MINOR=${TT_DEB_MINOR/p}
TT_VER=$(get_version_component_range 1-3)

DESCRIPTION="A Tool for analyzing network packet dumps"
HOMEPAGE="http://www.tcptrace.org/"
SRC_URI="
	http://www.tcptrace.org/download/${PN}-${TT_VER}.tar.gz
	http://www.tcptrace.org/download/old/6.6/${PN}-${TT_VER}.tar.gz
	mirror://debian/pool/main/t/${PN}/${PN}_${TT_VER}-${TT_DEB_MAJOR}.${TT_DEB_MINOR}.diff.gz
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"

S=${WORKDIR}/${PN}-${TT_VER}

src_prepare() {
	eapply "${FILESDIR}"/${PN}-${TT_VER}-cross-compile.patch
	eapply "${WORKDIR}"/${PN}_${TT_VER}-${TT_DEB_MAJOR}.${TT_DEB_MINOR}.diff

	eapply_user

	append-cppflags -D_DEFAULT_SOURCE

	eautoreconf
}

src_compile() {
	emake CCOPT="${CFLAGS}"
}

src_install() {
	dobin tcptrace xpl2gpl

	newman tcptrace.man tcptrace.1
	dodoc CHANGES COPYRIGHT FAQ README* THANKS WWW
}

pkg_postinst() {
	if ! has_version ${CATEGORY}/${PN}; then
		elog "Note: tcptrace outputs its graphs in the xpl (xplot)"
		elog "format. Since xplot is unavailable, you will have to"
		elog "use the included xpl2gpl utility to convert it to"
		elog "the gnuplot format."
	fi
}
