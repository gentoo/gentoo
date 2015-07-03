# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libspf2/libspf2-1.2.10.ebuild,v 1.5 2015/07/03 10:19:57 ago Exp $

EAPI=5
inherit autotools

DESCRIPTION="libspf2 implements the Sender Policy Framework, a part of the SPF/SRS protocol pair"
HOMEPAGE="http://www.libspf2.org"
SRC_URI="http://www.libspf2.org/spf/libspf2-${PV}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="static static-libs"

DEPEND=""
RDEPEND="!dev-perl/Mail-SPF-Query"
REQUIRED_USE="static? ( static-libs )"

src_prepare() {
	if ! use static; then
		sed -i -e '/bin_PROGRAMS/s/spfquery_static//' src/spfquery/Makefile.am \
			-e '/bin_PROGRAMS/s/spftest_static//' src/spftest/Makefile.am \
			-e '/bin_PROGRAMS/s/spfd_static//' src/spfd/Makefile.am \
			-e '/bin_PROGRAMS/s/spf_example_static//' src/spf_example/Makefile.am \
			|| die
		#eautoreconf
	fi

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README TODO INSTALL

	use static-libs || rm -f "${D}"/usr/lib*/libspf2.la
}
