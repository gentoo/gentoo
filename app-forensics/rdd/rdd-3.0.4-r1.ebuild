# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

# no worky
RESTRICT="test"

DESCRIPTION="Rdd is a forensic copy program"
HOMEPAGE="http://www.sf.net/projects/rdd"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
IUSE="debug doc"
LICENSE="BSD"
SLOT="0"

RDEPEND="app-forensics/libewf
	x11-libs/gtk+:2
	gnome-base/libglade:2.0"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}/rdd-3.0.4-sandbox-fix.patch"
	sed -i 's/AM_PATH_GTK_2_0//' configure.ac || die
	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	#doxygen-html fails but the docs are prebuilt so we don't need to enable them
	econf --disable-doxygen-html \
		$(use_enable debug tracing) \
		$(use_enable doc doxygen-doc)
}

src_compile() {
	emake -j1
}

src_install() {
	emake install DESTDIR="${D}"
	dobin src/rddi.py
	dosym rdd-copy /usr/bin/rdd
	#this causes a warning about not being recursive, no clue why
	dohtml -r doxygen-doc/html/*
}
