# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="libspf2 implements the Sender Policy Framework, a part of the SPF/SRS protocols"
HOMEPAGE="https://www.libspf2.org"
SRC_URI="https://www.libspf2.org/spf/libspf2-${PV}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

RDEPEND="!dev-perl/Mail-SPF-Query"

PATCHES=(
	"${FILESDIR}"/${P}-gcc5.patch #570486
)

src_prepare() {
	default

	sed -i -e '/bin_PROGRAMS/s/spfquery_static//' src/spfquery/Makefile.am \
		-e '/bin_PROGRAMS/s/spftest_static//' src/spftest/Makefile.am \
		-e '/bin_PROGRAMS/s/spfd_static//' src/spfd/Makefile.am \
		-e '/bin_PROGRAMS/s/spf_example_static//' src/spf_example/Makefile.am \
		|| die

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README TODO INSTALL

	find "${ED}" -name '*.la' -delete || die
}
