# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib versionator flag-o-matic

MY_PV=OpenCTM-${PV}

DESCRIPTION="OpenCTM - the Open Compressed Triangle Mesh."
HOMEPAGE="http://openctm.sourceforge.net"
SRC_URI="mirror://debian/pool/main/o/${PN}/${PN}_${PV}+dfsg1.orig.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/tinyxml
	media-libs/freeglut
	media-libs/glew
	media-libs/pnglite
	virtual/opengl
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PV}"

src_prepare() {
	epatch \
		"${FILESDIR}"/openctm-fix-makefiles.patch \
		"${FILESDIR}"/openctm-no-strip.patch
	mv Makefile.linux Makefile || die
	sed \
		-e "s:@GENTOO_LIBDIR@:$(get_libdir):g" \
		-i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX)
}
