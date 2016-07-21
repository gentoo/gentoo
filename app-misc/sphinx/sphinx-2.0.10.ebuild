# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools toolchain-funcs

#MY_P=${P/_/-}
MY_P=${P}-release

# This has been added by Gentoo, to explicitly version libstemmer.
# It is the date that http://snowball.tartarus.org/dist/libstemmer_c.tgz was
# fetched.
STEMMER_PV="20091122"
DESCRIPTION="Full-text search engine with support for MySQL and PostgreSQL"
HOMEPAGE="http://www.sphinxsearch.com/"
SRC_URI="http://sphinxsearch.com/files/${MY_P}.tar.gz
	stemmer? ( mirror://gentoo/libstemmer_c-${STEMMER_PV}.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE="debug id64 mysql odbc postgres stemmer test"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	odbc? ( dev-db/unixODBC )
	virtual/libiconv"
DEPEND="${RDEPEND}
	test? ( dev-lang/php )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use stemmer; then
		cd "${S}"
		unpack libstemmer_c-${STEMMER_PV}.tgz
	fi
}

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
		$(use_with stemmer libstemmer)

	cd api/libsphinxclient || die
	econf STRIP=:
}

src_compile() {
	emake AR="$(tc-getAR)" || die "emake failed"

	emake -j 1 -C api/libsphinxclient || die "emake libsphinxclient failed"
}

src_test() {
	elog "Tests require access to a live MySQL database and may require configuration."
	elog "You will find them in /usr/share/${PN}/test and they require dev-lang/php"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	emake DESTDIR="${D}" -C api/libsphinxclient install || die "install libsphinxclient failed"

	dodoc doc/*

	dodir /var/lib/sphinx
	dodir /var/log/sphinx

	newinitd "${FILESDIR}"/searchd.rc searchd

	if use test; then
		insinto /usr/share/${PN}
		doins -r test
	fi
}
