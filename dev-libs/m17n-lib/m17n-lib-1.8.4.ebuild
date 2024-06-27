# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

DESCRIPTION="Multilingual Library for Unix/Linux"
HOMEPAGE="https://www.nongnu.org/m17n/"
SRC_URI="mirror://nongnu/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="X anthy athena bidi fontconfig gd libotf libxml2 spell xft"

RDEPEND=">=dev-db/m17n-db-${PV}
	X? (
		x11-libs/libX11
		x11-libs/libXt
		athena? ( x11-libs/libXaw )
		bidi? ( dev-libs/fribidi )
		fontconfig? ( media-libs/fontconfig )
		gd? ( media-libs/gd[png] )
		libotf? ( dev-libs/libotf )
		xft? (
			media-libs/freetype
			x11-libs/libXft
		)
	)
	anthy? ( app-i18n/anthy )
	libxml2? ( dev-libs/libxml2 )
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-configure.patch
	"${FILESDIR}"/${PN}-freetype.patch
	"${FILESDIR}"/${PN}-ispell.patch
)

src_prepare() {
	default

	eautoreconf
	# workaround for parallel install
	sed -i "/^install-module/s/:/: install-libLTLIBRARIES/" src/Makefile.in
}

src_configure() {
	local myconf=(
		$(use_with anthy)
		$(use_with libxml2)
		$(use_with spell ispell)
	)
	if use X; then
		myconf+=(
			$(use_with athena)
			$(use_with bidi fribidi)
			$(use_with fontconfig)
			$(use_with xft freetype)
			$(use_with gd)
			--with-gui
			$(use_with libotf)
			--with-x
			$(use_with xft)
		)
	else
		myconf+=(
			--without-athena
			--without-fontconfig
			--without-freetype
			--without-fribidi
			--without-gd
			--without-gui
			--without-libotf
			--without-x
			--without-xft
		)
	fi

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
