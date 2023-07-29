# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="ROM management tools and library"
HOMEPAGE="https://sourceforge.net/projects/mamory/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/expat"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Make sure the system expat is used
	sed -i \
		-e 's/#ifdef.*SYSEXPAT/#if 1/' \
		mamory/amlxml.c mamory/amlxml.h || die

	# Remove hardcoded CFLAGS options
	sed -i \
		-e '/AC_ARG_ENABLE(debug,/ {N;N;N;d}' \
		configure.ac || die

	# Make it possible for eautoreconf to fix fPIC etc.
	sed -i \
		-e '/libcommon_la_LDFLAGS= -static/d' \
		common/Makefile.am || die

	AT_M4DIR="config" eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #570500)
}

src_configure() {
	econf \
		--includedir="${EPREFIX}"/usr/include
}

src_install() {
	HTML_DOCS="DOCS/mamory.html" default
	find "${D}" -name '*.la' -delete || die
}
