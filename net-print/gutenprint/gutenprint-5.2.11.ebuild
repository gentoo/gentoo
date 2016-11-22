# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Ghostscript and cups printer drivers"
HOMEPAGE="http://gutenprint.sourceforge.net"
SRC_URI="mirror://sourceforge/gimp-print/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cups foomaticdb gimp gtk nls readline ppds static-libs"
REQUIRED_USE="gimp? ( gtk )"

RDEPEND="app-text/ghostscript-gpl
	dev-lang/perl
	readline? ( sys-libs/readline:0= )
	cups? ( >=net-print/cups-1.1.14 )
	foomaticdb? ( net-print/foomatic-db-engine )
	gimp? ( >=media-gfx/gimp-2.2 x11-libs/gtk+:2 )
	gtk? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README doc/gutenprint-users-manual.{pdf,odt} )

PATCHES=(
	"${FILESDIR}"/${PN}-5.2.4-CFLAGS.patch
	"${FILESDIR}"/${PN}-5.2.10-genppd.patch # bug 382927
	"${FILESDIR}"/${PN}-switch-from-ijs-config-to-pkg-config.patch # bug 587916
)

src_prepare() {
	default

	sed -i "s:m4local:m4extra:" Makefile.am || die

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" \
		-e "s/AM_PROG_CC_STDC/AC_PROG_CC/" \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-test
		--with-ghostscript
		--disable-translated-cups-ppds
		$(use_enable gtk libgutenprintui2)
		$(use_with gimp gimp2)
		$(use_with gimp gimp2-as-gutenprint)
		$(use_with cups)
		$(use_enable nls)
		$(use_with readline)
		$(use_enable static-libs static)
	)

	if use cups && use ppds; then
		myeconfargs+=( --enable-cups-ppds --enable-cups-level3-ppds )
	else
		myeconfargs+=( --disable-cups-ppds )
	fi

	use foomaticdb \
		&& myeconfargs+=( --with-foomatic3 ) \
		|| myeconfargs+=( --without-foomatic )

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc doc/FAQ.html
	dodoc -r doc/gutenprintui2/html
	rm -r "${ED}"/usr/share/gutenprint/doc || die

	find "${ED}" -name '*.la' -exec rm -f '{}' + || die
}

pkg_postinst() {
	if [[ ${ROOT} == / ]] && [[ -x /usr/sbin/cups-genppdupdate ]]; then
		elog "Updating installed printer ppd files"
		elog $(/usr/sbin/cups-genppdupdate)
	else
		elog "You need to update installed ppds manually using cups-genppdupdate"
	fi
}
