# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tabular Datastream Library"
HOMEPAGE="https://www.freetds.org/"
SRC_URI="
	https://www.freetds.org/files/stable/${P}.tar.bz2
	https://github.com/FreeTDS/freetds/releases/download/v${PV}/${P}.tar.bz2
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="debug gnutls iconv kerberos mssql iodbc odbc ssl static-libs"
# iODBC and unixODBC are mutually-exclusive choices for
# the ODBC driver manager. Future versions of FreeTDS
# will throw an error if you specify both.
REQUIRED_USE="?? ( iodbc odbc )"
# Nearly wired up as of 1.4.26 but had link failures like
# all_types: hidden symbol `tds_convert' isn't defined
RESTRICT="test"

DEPEND="
	gnutls? ( net-libs/gnutls:= )
	iconv? ( virtual/libiconv )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	odbc? ( dev-db/unixODBC )
	ssl? ( dev-libs/openssl:= )
"
# bind-tools is needed because the osql script calls "host".
RDEPEND="
	${DEPEND}
	net-dns/bind
"

DOCS=( {NEWS,README}.md )

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable debug)
		$(use_enable iconv libiconv)
		$(use_enable kerberos krb5)
		$(use_enable mssql msdblib)
		$(use_with gnutls)
		$(use_with iodbc)
		$(use_with iconv libiconv-prefix "${EPREFIX}/usr")
		$(use_with odbc unixodbc "${EPREFIX}/usr")
		$(use_with ssl openssl "${EPREFIX}/usr")
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# These tests need a running database.
	local XFAIL_TESTS=(
		corrupt dataread dynamic1 nulls
		t000{1..6} toodynamic utf8_{1..3}
	)

	emake check XFAIL_TESTS="${XFAIL_TESTS[*]}"
}

src_install() {
	default

	find "${D}" -type f -name '*.la' -delete || die
}
