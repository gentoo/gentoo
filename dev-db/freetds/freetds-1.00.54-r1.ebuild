# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Tabular Datastream Library"
HOMEPAGE="http://www.freetds.org/"
SRC_URI="ftp://ftp.freetds.org/pub/freetds/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos"
IUSE="gnutls iconv kerberos libressl mssql iodbc odbc ssl"
RESTRICT="test"

# sed, grep, and awk are used by the build system and the osql script.
COMMON_DEPEND="sys-apps/sed
	sys-apps/grep
	virtual/awk
	gnutls? ( net-libs/gnutls )
	iconv? ( virtual/libiconv )
	iodbc? ( dev-db/libiodbc )
	kerberos? ( virtual/krb5 )
	odbc? ( dev-db/unixODBC )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)"

DEPEND="${COMMON_DEPEND}"

# bind-tools is needed because the osql script calls "host".
# binutils is for "strings".
RDEPEND="${COMMON_DEPEND}
	sys-devel/binutils
	net-dns/bind-tools"

# iODBC and unixODBC are mutually-exclusive choices for
# the ODBC driver manager. Future versions of FreeTDS
# will throw an error if you specify both.
REQUIRED_USE="?? ( iodbc odbc )"

# Won't be necessary in the next release.
PATCHES=( "${FILESDIR}/without-flags.patch" )

src_prepare() {
	default

	# Fix the iodbc include path in the configure script. Otherwise, it
	# can't find isql.h.
	sed -ie 's:with_iodbc/include":with_iodbc/include/iodbc":' \
		configure.ac \
		|| die "failed to fix the iodbc include path in configure.ac"

	eautoreconf
}

src_configure() {
	local myconf=( $(use_with iodbc iodbc "${EPREFIX}/usr") )
	myconf+=( $(use_with odbc unixodbc "${EPREFIX}/usr") )
	myconf+=( $(use_enable iconv libiconv) )
	myconf+=( $(use_with iconv libiconv-prefix "${EPREFIX}/usr") )
	myconf+=( $(use_enable kerberos krb5) )
	myconf+=( $(use_enable mssql msdblib) )
	myconf+=( $(use_with gnutls) )
	myconf+=( $(use_with ssl openssl "${EPREFIX}/usr") )
	myconf+=( --docdir="/usr/share/doc/${PF}" )

	econf "${myconf[@]}"
}
