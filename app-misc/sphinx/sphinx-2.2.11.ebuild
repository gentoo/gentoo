# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WANT_AUTOMAKE=1.15

inherit eutils autotools toolchain-funcs

#MY_P=${P/_/-}
MY_P=${P}-release

DESCRIPTION="Full-text search engine with support for MySQL and PostgreSQL"
HOMEPAGE="http://www.sphinxsearch.com/"
SRC_URI="http://sphinxsearch.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="debug +id64 mysql odbc postgres re2 stemmer syslog xml"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:* )
	odbc? ( dev-db/unixODBC )
	re2? ( dev-libs/re2 )
	stemmer? ( dev-libs/snowball-stemmer )
	xml? ( dev-libs/expat )
	virtual/libiconv"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.1_beta-darwin8.patch

	# drop nasty hardcoded search path breaking Prefix
	# We patch configure directly since otherwise we need to run
	# eautoreconf twice and that causes problems, bug 425380
	sed -i -e 's/\/usr\/local\//\/someplace\/nonexisting\//g' configure || die

	# Fix QA compilation warnings.
	sed -i -e '19i#include <string.h>' api/libsphinxclient/test.c || die

	pushd api/libsphinxclient || die
	eautoreconf
	popd || die

	# Drop bundled code to ensure building against system versions. We
	# cannot remove libstemmer_c since configure updates its Makefile.
	rm -rf libexpat libre2 || die
}

src_configure() {
	# fix libiconv detection
	use !elibc_glibc && export ac_cv_search_iconv=-liconv

	econf \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
		$(use_enable id64) \
		$(use_with debug) \
		$(use_with mysql) \
		$(use_with odbc unixodbc) \
		$(use_with postgres pgsql) \
		$(use_with re2) \
		$(use_with stemmer libstemmer) \
		$(use_with syslog syslog) \
		$(use_with xml libexpat )

	cd api/libsphinxclient || die
	econf STRIP=:
}

src_compile() {
	emake AR="$(tc-getAR)"

	emake -j 1 -C api/libsphinxclient
}

src_test() {
	# Tests require a live database and only work from the source
	# directory.
	:
}

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" -C api/libsphinxclient install

	dodoc doc/*

	dodir /var/lib/sphinx
	dodir /var/log/sphinx

	newinitd "${FILESDIR}"/searchd.rc searchd
}
