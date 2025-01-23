# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tabular Datastream Library"
HOMEPAGE="https://www.freetds.org/"
SRC_URI="https://www.freetds.org/files/stable/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~ppc-macos"
IUSE="debug gnutls iconv kerberos mssql iodbc odbc ssl static-libs"
# iODBC and unixODBC are mutually-exclusive choices for
# the ODBC driver manager. Future versions of FreeTDS
# will throw an error if you specify both.
REQUIRED_USE="?? ( iodbc odbc )"
# Nearly wired up as of 1.4.23 but had link failures
RESTRICT="test"

COMMON_DEPEND="
	app-alternatives/awk
	gnutls? ( net-libs/gnutls:= )
	iconv? ( virtual/libiconv )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	odbc? ( dev-db/unixODBC )
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${COMMON_DEPEND}"
# bind-tools is needed because the osql script calls "host".
RDEPEND="
	${COMMON_DEPEND}
	net-dns/bind-tools
"

src_configure() {
	econf \
		--enable-shared \
		$(use_enable debug) \
		$(use_enable iconv libiconv) \
		$(use_enable kerberos krb5) \
		$(use_enable mssql msdblib) \
		$(use_with iodbc) \
		$(use_with odbc unixodbc "${EPREFIX}/usr") \
		$(use_with iconv libiconv-prefix "${EPREFIX}/usr") \
		$(use_with gnutls) \
		$(use_with ssl openssl "${EPREFIX}/usr")
}

src_test() {
	# These tests need a running database.
	local XFAIL_TESTS=(
		corrupt dataread dynamic1 nulls
		t0001 t0002 t0003 t0004 t0005 t0006
		toodynamic utf8_1 utf8_2 utf8_3
	)

	emake check XFAIL_TESTS="${XFAIL_TESTS[*]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
