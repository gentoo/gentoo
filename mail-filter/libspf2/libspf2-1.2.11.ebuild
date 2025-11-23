# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

GHASH=4915c308d57ff3abac9fb241f09c4bed2ab54815  # 1.2.11
DESCRIPTION="implementation of Sender Policy Framework (SPF)"
HOMEPAGE="https://www.libspf2.net/"
SRC_URI="https://github.com/shevek/${PN}/archive/${GHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 BSD-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-memset-include-string-h.patch
	"${FILESDIR}"/${PN}-1.2.11-undefined-dn_.patch
	"${FILESDIR}"/${PN}-1.2.11-musl.patch
)

S=${WORKDIR}/${PN}-${GHASH}

src_prepare() {
	default

	sed -i -e '/bin_PROGRAMS/s/spfquery_static//' src/spfquery/Makefile.am \
		-e '/bin_PROGRAMS/s/spftest_static//' src/spftest/Makefile.am \
		-e '/bin_PROGRAMS/s/spfd_static//' src/spfd/Makefile.am \
		-e '/bin_PROGRAMS/s/spf_example_static//' src/spf_example/Makefile.am \
		|| die

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	sed -i -e '/AX_WITH_PERL/d' configure.ac || die # bug 885055

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
