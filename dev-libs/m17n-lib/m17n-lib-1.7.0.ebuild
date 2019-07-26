# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Multilingual Library for Unix/Linux"
HOMEPAGE="https://savannah.nongnu.org/projects/m17n https://git.savannah.nongnu.org/cgit/m17n/m17n-lib.git"
SRC_URI="mirror://nongnu/m17n/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE="X anthy athena bidi fontconfig gd libotf libxml2 spell xft"

RDEPEND="~dev-db/m17n-db-${PV}
	X? (
		x11-libs/libX11
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
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-configure.patch
	"${FILESDIR}"/${PN}-freetype.patch
	"${FILESDIR}"/${PN}-ispell.patch
	"${FILESDIR}"/${PN}-parallel-make.patch
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
