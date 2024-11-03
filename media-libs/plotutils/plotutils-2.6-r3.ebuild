# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool autotools greadme

DESCRIPTION="Powerful C/C++ function library for exporting 2-D vector graphics"
HOMEPAGE="https://www.gnu.org/software/plotutils/"
SRC_URI="mirror://gnu/plotutils/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
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
	"${FILESDIR}"/${P}-configure-c99.patch
	"${FILESDIR}"/${P}-cxx17-fix.patch
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

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die

	if use X ; then
		greadme_stdin <<-EOF
			There are extra fonts available in the plotutils package.
			The current ebuild does not install them for you since most
			of them can be installed via the media-fonts/urw-fonts
			package. See /usr/share/doc/${PF}/INSTALL.fonts for
			information on installing the remaining Tektronix fonts.

			If you manually install the extra fonts and use the
			program xfig, you might want to recompile to take
			advantage of the additional ps fonts.
			Also, it is possible to enable ghostscript and your
			printer to use the HP fonts.
		EOF
	fi
}
