# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Split files into smaller pieces and combine them back together"
HOMEPAGE="http://gtk-splitter.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="crypt"

RDEPEND="x11-libs/gtk+:2
	virtual/libintl:0
	crypt? ( >=app-crypt/mhash-0.8:0 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig:*"

src_prepare() {
	epatch "${FILESDIR}/"${P}-r1-desktop-QA-fixes.patch
}

src_compile() {
	default

	if ! use crypt ; then
		# configure script only autodetects
		sed -i -e 's:-lmhash::' -e 's:-DHAVE_LIBMHASH=1::' src/Makefile || die
	fi
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install
}
