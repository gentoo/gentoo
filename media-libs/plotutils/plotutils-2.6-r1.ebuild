# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit libtool eutils autotools

DESCRIPTION="Powerful C/C++ function library for exporting 2-D vector graphics"
HOMEPAGE="https://www.gnu.org/software/plotutils/"
SRC_URI="mirror://gnu/plotutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+png static-libs X"

DEPEND="
	!<media-libs/plotutils-${PV}
	media-libs/libxmi
	png? (
		media-libs/libpng
		sys-libs/zlib )
	X? (
		x11-libs/libXaw
		x11-proto/xextproto )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS COMPAT ChangeLog INSTALL.* KNOWN_BUGS NEWS ONEWS PROBLEMS README THANKS TODO"

src_prepare() {
	rm -rf libxmi/* || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	epatch \
		"${FILESDIR}"/${PN}-2.5.1-rangecheck.patch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-libpng-1.5.patch \
		"${FILESDIR}"/${P}-libxmi.patch
	eautoreconf
	elibtoolize
}

src_configure() {
	local myconf
	if use X ; then
		myconf="--with-x --enable-libxmi"
	else
		myconf="--without-x"
	fi

	econf \
		--disable-dependency-tracking \
		--enable-shared \
		--enable-libplotter \
		--disable-libxmi \
		$(use_enable static-libs static) \
		$(use_with png libpng) \
		${myconf}
}

pkg_postinst() {
	if use X ; then
		elog "There are extra fonts available in the plotutils package."
		elog "The current ebuild does not install them for you since most"
		elog "of them can be installed via the media-fonts/urw-fonts"
		elog "package. See /usr/share/doc/${P}/INSTALL.fonts for"
		elog "information on installing the remaining Tektronix fonts."
		elog ""
		elog "If you manually install the extra fonts and use the"
		elog "program xfig, you might want to recompile to take"
		elog "advantage of the additional ps fonts."
		elog "Also, it is possible to enable ghostscript and possibly"
		elog "your printer to use the HP fonts."
	fi
}
