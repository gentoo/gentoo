# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools qmake-utils

DESCRIPTION="Application and libary for hinting TrueType fonts"
HOMEPAGE="https://freetype.org/ttfautohint"
SRC_URI="https://download.savannah.gnu.org/releases/freetype/${P}.tar.gz"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0/1.0.3"
KEYWORDS="~amd64"
IUSE="qt5"

RDEPEND="
	media-libs/freetype
	media-libs/harfbuzz:=
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
"

src_prepare() {
	default

	# Don't invoke git to get the version number.
	sed "s|m4_esyscmd.*VERSION)|${PV//_/-}|" -i configure.ac || die

	# musl does not define _Bool for c++, bug #836426
	sed 's/_Bool/bool/' -i lib/llrb.h || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--without-doc
		--with-qt="$(usex qt5 $(qt5_get_bindir) no)"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	doman frontend/ttfautohint.1
	use qt5 && doman frontend/ttfautohintGUI.1

	find "${ED}" -name '*.la' -delete || die
}
