# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Translate DVI files into PNG or GIF graphics"
HOMEPAGE="http://dvipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+ Texinfo-manual"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="truetype test"

RDEPEND="
	dev-libs/kpathsea:=
	media-libs/gd:2=[jpeg,png]
	media-libs/libpng:0=
	virtual/latex-base
	sys-libs/zlib
	truetype? ( >=media-libs/freetype-2.1.5 )"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	virtual/pkgconfig
	test? ( dev-texlive/texlive-fontsrecommended )"

DOCS="ChangeLog README RELEASE"

src_configure() {
	has_version '>=dev-libs/kpathsea-6.2.1' && append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"
	if ! use truetype; then
		sed -i -e 's/FT_Init_FreeType/dIsAbLe&/' configure || die "sed failed"
	fi

	export VARTEXFONTS="${T}/fonts"
	econf
}
