# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/plotutils/plotutils-2.6.ebuild,v 1.12 2013/05/04 21:06:53 jlec Exp $

EAPI=3
inherit libtool eutils autotools

DESCRIPTION="a powerful C/C++ function library for exporting 2-D vector graphics"
HOMEPAGE="http://www.gnu.org/software/plotutils/"
SRC_URI="mirror://gnu/plotutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="+png static-libs X"

DEPEND="
	!media-libs/libxmi
	png? ( media-libs/libpng
		sys-libs/zlib )
	X? ( x11-libs/libXaw
		x11-proto/xextproto )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.5.1-rangecheck.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"
	epatch "${FILESDIR}/${P}-libpng-1.5.patch"
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac
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
		$(use_enable static-libs static) \
		$(use_with png libpng) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COMPAT ChangeLog INSTALL.* \
		KNOWN_BUGS NEWS ONEWS PROBLEMS README THANKS TODO
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
