# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

#MY_P=${P/_/-}
MY_P=${P}-release

DESCRIPTION="Full-text search engine with support for MySQL and PostgreSQL"
HOMEPAGE="https://sphinxsearch.com/"
SRC_URI="https://sphinxsearch.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="debug +id64 mariadb mysql odbc postgres stemmer syslog xml"

REQUIRED_USE="mysql? ( !mariadb ) mariadb? ( !mysql )"

RDEPEND="
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	odbc? ( dev-db/unixODBC )
	stemmer? ( dev-libs/snowball-stemmer:= )
	xml? ( dev-libs/expat )
	virtual/libiconv"

S=${WORKDIR}/${MY_P}

src_prepare() {
	eapply -p0 "${FILESDIR}"/${PN}-2.0.1_beta-darwin8.patch
	eapply "${FILESDIR}"/${P}-automake-1.16.patch

	# drop nasty hardcoded search path breaking Prefix
	# We patch configure directly since otherwise we need to run
	# eautoreconf twice and that causes problems, bug 425380
	sed -i -e 's/\/usr\/local\//\/someplace\/nonexisting\//g' configure || die

	if use mariadb ; then
		sed -i -e 's/mysql_config/mariadb_config/g' configure || die
	fi

	# Fix QA compilation warnings.
	sed -i -e '19i#include <string.h>' api/libsphinxclient/test.c || die

	eapply_user

	pushd api/libsphinxclient || die
	eautoreconf
	popd || die

	# Drop bundled code to ensure building against system versions. We
	# cannot remove libstemmer_c since configure updates its Makefile.
	rm -rf libexpat || die
}

src_configure() {
	# bug #854738
	append-flags -fno-strict-aliasing
	filter-lto
	# This code is no longer maintained and not compatible with modern C/C++ standards, bug #880923
	append-cflags -std=gnu89
	append-cxxflags -std=c++11

	# fix libiconv detection
	use !elibc_glibc && export ac_cv_search_iconv=-liconv

	local mysql_with
	if use mysql || use mariadb ; then
		mysql_with="--with-mysql"
	else
		mysql_with="--without-mysql"
	fi

	econf \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
		$(use_enable id64) \
		$(use_with debug) \
		${mysql_with} \
		$(use_with odbc unixodbc) \
		$(use_with postgres pgsql) \
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

	# Remove unneeded empty directories.
	rmdir "${D}"/var/lib/{data,log}

	dodoc doc/*

	keepdir /var/lib/sphinx
	keepdir /var/log/sphinx

	newinitd "${FILESDIR}"/searchd.rc searchd
}
