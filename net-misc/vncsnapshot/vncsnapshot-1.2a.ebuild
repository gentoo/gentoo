# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vncsnapshot/vncsnapshot-1.2a.ebuild,v 1.10 2012/06/25 17:42:43 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="A command-line tool for taking JPEG snapshots of VNC servers"
HOMEPAGE="http://vncsnapshot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="
	virtual/jpeg
	>=sys-libs/zlib-1.1.4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-amd64grey.patch"
	sed \
		-e 's:-I/usr/local/include::g' \
		-e 's:-L/usr/local/lib::g' \
		-e '/^all:/s|$(SUBDIRS:.dir=.all)||g' \
		-e '/^vnc/s|$| $(SUBDIRS:.dir=.all)|g' \
		-i Makefile || die
}

src_compile() {
	#note: We override CDEBUGFLAGS instead of CFLAGS because otherwise
	#      we lost the INCLUDES in the makefile.
	# bug #295741
	emake CDEBUGFLAGS="${CXXFLAGS}" CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	dobin vncsnapshot
	cp vncsnapshot.man1 vncsnapshot.1
	doman vncsnapshot.1
}
