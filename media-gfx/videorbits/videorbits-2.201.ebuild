# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/videorbits/videorbits-2.201.ebuild,v 1.17 2011/08/07 23:39:53 ssuominen Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="a collection of programs for creating high dynamic range images"
HOMEPAGE="http://comparametric.sourceforge.net/"
SRC_URI="mirror://sourceforge/comparametric/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	sys-libs/zlib
	media-libs/libpng
	virtual/jpeg"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README README.MORE )

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch

	sed -i \
		-e "s:\$(prefix)/images:\$(prefix)/share/${PN}/images:" \
		images/Makefile.in || die

	sed -i \
		-e "s:\$(prefix)/lookuptables:\$(prefix)/share/${PN}/lookuptables:" \
		lookuptables/Makefile.in || die
}

src_configure() {
	tc-export CC
	econf
}
