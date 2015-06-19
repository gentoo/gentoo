# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipng/dvipng-1.14.ebuild,v 1.13 2014/11/01 17:07:08 ulm Exp $

EAPI=5

inherit eutils

DESCRIPTION="Translate DVI files into PNG or GIF graphics"
HOMEPAGE="http://dvipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+ Texinfo-manual"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="t1lib truetype test"

RDEPEND="
	dev-libs/kpathsea
	media-libs/gd[jpeg,png]
	media-libs/libpng
	virtual/latex-base
	sys-libs/zlib
	t1lib? ( media-libs/t1lib )
	truetype? ( >=media-libs/freetype-2.1.5 )"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	test? ( dev-texlive/texlive-fontsrecommended )"

DOCS="ChangeLog README RELEASE"

src_prepare() {
	epatch "${FILESDIR}"/${P}-wait.patch
}

src_configure() {
	if ! use t1lib; then
		# The build system autodetects libt1. We don't want that if the
		# USE flag is not set, so confuse it with a wrong name.
		sed -i -e 's/T1_InitLib/dIsAbLe&/' configure || die "sed failed"
	fi

	if ! use truetype; then
		sed -i -e 's/FT_Init_FreeType/dIsAbLe&/' configure || die "sed failed"
	fi

	export VARTEXFONTS="${T}/fonts"
	econf
}
