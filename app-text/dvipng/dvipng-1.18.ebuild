# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Translate DVI files into PNG or GIF graphics"
HOMEPAGE="https://dvipng.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
S="${WORKDIR}"

LICENSE="LGPL-3+ Texinfo-manual"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="truetype test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/kpathsea-6.2.1:=
	media-libs/gd:2=[jpeg,png]
	media-libs/libpng:0=
	virtual/latex-base
	virtual/zlib:=
	truetype? ( >=media-libs/freetype-2.1.5 )"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	virtual/pkgconfig
	test? ( dev-texlive/texlive-fontsrecommended )"

DOCS="ChangeLog README RELEASE"

src_configure() {
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"
	if ! use truetype; then
		sed -i -e 's/\(--exists.*\)freetype2/\1dIsAbLe/' configure \
			|| die "sed failed"
	fi

	export VARTEXFONTS="${T}/fonts"
	econf
}
