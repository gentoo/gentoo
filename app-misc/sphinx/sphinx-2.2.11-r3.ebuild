# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

WANT_AUTOMAKE="1.15"

inherit eutils autotools toolchain-funcs

#MY_P=${P/_/-}
MY_P="${P}-release"

DESCRIPTION="Full-text search engine with support for MySQL and PostgreSQL"
HOMEPAGE="http://www.sphinxsearch.com/"
SRC_URI="http://sphinxsearch.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris"
IUSE="debug +id64 mariadb mysql odbc postgres re2 stemmer syslog xml"

REQUIRED_USE="mysql? ( !mariadb ) mariadb? ( !mysql )"

RDEPEND="
	mariadb?	( dev-db/mariadb-connector-c )
	mysql?		( dev-db/mysql-connector-c )
	odbc?		( dev-db/unixODBC )
	postgres?	( dev-db/postgresql:* )
	re2?		( dev-libs/re2 )
	stemmer?	( dev-libs/snowball-stemmer )
	xml?		( dev-libs/expat )
	virtual/libiconv"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply -p0 "${FILESDIR}"/${PN}-2.0.1_beta-darwin8.patch

	# drop nasty hardcoded search path breaking Prefix
	# We patch configure directly since otherwise we need to run
	# eautoreconf twice and that causes problems, bug 425380
	sed -i -e 's/\/usr\/local\//\/someplace\/nonexisting\//g' configure || die

	if use mariadb ; then
		sed -i -e 's/mysql_config/mariadb_config/g' configure || die
	fi

	# Fix QA compilation warnings.
	sed -i -e '19i#include <string.h>' api/libsphinxclient/test.c || die
	sed -i -e 's/libsphinxclient.a/libsphinxclient.so/g' api/libsphinxclient/Makefile.am || die
	eapply_user

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

	local myconf=(
		--sysconfdir="${EPREFIX}/etc/${PN}"
		--with-re2-libs="${EPREFIX}/usr/$(get_libdir)/libre2.so"
		$(use_enable id64)
		$(use_with debug)
		$(use_with odbc unixodbc)
		$(use_with postgres pgsql)
		$(use_with re2)
		$(use_with stemmer libstemmer)
		$(use_with syslog syslog)
		$(use_with xml libexpat)
	)

	if use mysql || use mariadb ; then
		myconf+=( --with-mysql )
	else
		myconf+=( --without-mysql )
	fi

	econf "${myconf[@]}"

	cd api/libsphinxclient || die
	econf --disable-static STRIP=:
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
	default
	emake DESTDIR="${D}" -C api/libsphinxclient install
	find "${D}" -name '*.la' -delete || die

	dodoc -r doc/.

	dodir /var/lib/sphinx
	dodir /var/log/sphinx

	newinitd "${FILESDIR}/searchd.rc" searchd
}
