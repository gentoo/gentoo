# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Japanese handwriting recognition tool"
HOMEPAGE="http://fishsoup.net/software/kanjipad/"
SRC_URI="http://fishsoup.net/software/kanjipad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc64"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch \
		"${FILESDIR}"/${P}-underlinking.patch
}

src_compile() {
	tc-export CC
	perl -i -pe "s|PREFIX=/usr/local|PREFIX=/usr|;
		s|-DG.*DISABLE_DEPRECATED||g" Makefile || die

	emake || die
}

src_install() {
	dobin kanjipad kpengine || die
	insinto /usr/share/kanjipad
	doins jdata.dat || die
	dodoc ChangeLog README TODO jstroke/README-kanjipad
}
