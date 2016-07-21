# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils multilib toolchain-funcs

DESCRIPTION="Interface to the XKEYBOARD extension in X11"
HOMEPAGE="http://cita.disability.uiuc.edu/software/accessx/freewareaccessx.php"
SRC_URI="http://cmos-eng.rehab.uiuc.edu/${PN}/software/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXext
	dev-lang/tk"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch

	sed -i \
		-e 's:$(CC) $(OPTS) ax.C:$(CC) $(LDFLAGS) $(OPTS) ax.C:' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCXX)" OPTS="${CXXFLAGS}" \
		XLIBDIR="-L/usr/$(get_libdir)" LLIBS="-lXext -lX11" || die
}

src_install() {
	dobin accessx ax || die
	dodoc CHANGES README
}
