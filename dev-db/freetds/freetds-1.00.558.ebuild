# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is from the "current" release series, because the "stable" series
# is a little too stable for us (missing bug fixes, and so on).
MY_PN="${PN}-dev"

DESCRIPTION="Tabular Datastream Library"
HOMEPAGE="https://www.freetds.org/"
SRC_URI="ftp://ftp.freetds.org/pub/${PN}/current/${MY_PN}.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-macos"

IUSE="debug gnutls iconv kerberos libressl mssql iodbc odbc ssl static-libs"
# iODBC and unixODBC are mutually-exclusive choices for
# the ODBC driver manager. Future versions of FreeTDS
# will throw an error if you specify both.
REQUIRED_USE="?? ( iodbc odbc )"

RESTRICT="test"

# sed, grep, and awk are used by the build system and the osql script.
COMMON_DEPEND="
	sys-apps/sed
	sys-apps/grep
	virtual/awk
	gnutls? ( net-libs/gnutls:= )
	iconv? ( virtual/libiconv )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	odbc? ( dev-db/unixODBC )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="${COMMON_DEPEND}"

# bind-tools is needed because the osql script calls "host".
# binutils is for "strings".
RDEPEND="${COMMON_DEPEND}
	sys-devel/binutils
	net-dns/bind-tools
"

S="${WORKDIR}/${MY_PN}.${PV}"

src_configure() {
	econf \
		--enable-shared \
		$(use_enable debug) \
		$(use_enable iconv libiconv) \
		$(use_enable kerberos krb5) \
		$(use_enable mssql msdblib) \
		$(use_enable static-libs static) \
		$(use_with iodbc) \
		$(use_with odbc unixodbc "${EPREFIX}/usr") \
		$(use_with iconv libiconv-prefix "${EPREFIX}/usr") \
		$(use_with gnutls) \
		$(use_with ssl openssl "${EPREFIX}/usr")
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
