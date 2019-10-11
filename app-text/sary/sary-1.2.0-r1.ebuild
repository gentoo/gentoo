# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools

DESCRIPTION="Sary: suffix array library and tools"
HOMEPAGE="http://sary.sourceforge.net/"
SRC_URI="http://sary.sourceforge.net/${P}.tar.gz"
IUSE="static-libs"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
RESTRICT="test"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	echo "libsary_la_LIBADD = @GLIB_LIBS@" >> sary/Makefile.am || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die
	eautoreconf
}
src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" \
		docsdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		install

	dodoc AUTHORS ChangeLog NEWS README TODO

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete
	fi

}
