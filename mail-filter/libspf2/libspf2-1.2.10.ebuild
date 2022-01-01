# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="libspf2 implements the Sender Policy Framework, a part of the SPF/SRS protocols"
HOMEPAGE="https://www.libspf2.org"
SRC_URI="https://www.libspf2.org/spf/libspf2-${PV}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
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
	epatch "${FILESDIR}"/${P}-gcc5.patch #570486

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
