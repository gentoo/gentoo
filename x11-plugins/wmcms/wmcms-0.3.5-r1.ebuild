# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="WindowMaker CPU and Memory Usage Monitor Dock App"
SRC_URI="http://orbita.starmedia.com/~neofpo/files/${P}.tar.bz2"
HOMEPAGE="http://orbita.starmedia.com/~neofpo/wmcms.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="<x11-libs/libdockapp-0.7"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/wmcms-0.3.5-s4t4n.patch

	# Respect LDFLAGS, see bug #335031
	sed -i 's/ -o wmcms/ ${LDFLAGS} -o wmcms/' "Makefile"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin wmcms || die "dobin failed."
}
