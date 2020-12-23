# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool autotools

DESCRIPTION="Powerful C/C++ function library for exporting 2-D vector graphics"
HOMEPAGE="https://www.gnu.org/software/plotutils/"
SRC_URI="mirror://gnu/plotutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+png X"

DEPEND="
	media-libs/libxmi
	png? (
		media-libs/libpng:0=
		sys-libs/zlib
	)
	X? ( x11-libs/libXaw )
"
RDEPEND="${DEPEND}
	!<media-libs/plotutils-${PV}
"

DOCS=( AUTHORS COMPAT ChangeLog INSTALL.{fonts,pkg} KNOWN_BUGS NEWS ONEWS PROBLEMS README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.1-rangecheck.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-libpng-1.5.patch
	"${FILESDIR}"/${P}-libxmi.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default

	rm -r libxmi/* || die
	sed -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' -i configure.ac || die

	eautoreconf
	elibtoolize
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		--enable-libplotter
		--disable-libxmi
		--disable-static
		$(use_with png libpng)
		$(usex X "--with-x --enable-libxmi" "--without-x")
	)
	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	if use X ; then
		elog "There are extra fonts available in the plotutils package."
		elog "The current ebuild does not install them for you since most"
		elog "of them can be installed via the media-fonts/urw-fonts"
		elog "package. See /usr/share/doc/${PF}/INSTALL.fonts for"
		elog "information on installing the remaining Tektronix fonts."
		elog ""
		elog "If you manually install the extra fonts and use the"
		elog "program xfig, you might want to recompile to take"
		elog "advantage of the additional ps fonts."
		elog "Also, it is possible to enable ghostscript and possibly"
		elog "your printer to use the HP fonts."
	fi
}
