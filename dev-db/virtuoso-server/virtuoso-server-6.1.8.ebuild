# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/virtuoso-server/virtuoso-server-6.1.8.ebuild,v 1.2 2015/05/08 15:50:16 jer Exp $

EAPI=5

inherit virtuoso

DESCRIPTION="Server binaries for Virtuoso, high-performance object-relational SQL database"

KEYWORDS="~amd64 ~arm ~ppc ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="kerberos ldap readline"

# Bug 305077
RESTRICT="test"

# zeroconf support looks like broken - disabling - last checked around 5.0.12
# mono support fetches mono source and compiles it manually - disabling for now
# mono? ( dev-lang/mono )
COMMON_DEPEND="
	dev-libs/libxml2:2
	>=dev-libs/openssl-0.9.7i:0
	>=sys-libs/zlib-1.2.5.1-r2:0[minizip]
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	readline? ( sys-libs/readline:0 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gperf-2.7.2
	sys-apps/gawk
	>=sys-devel/bison-2.3
	>=sys-devel/flex-2.5.33
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	~dev-db/virtuoso-odbc-${PV}:${SLOT}
"

VOS_EXTRACT="
	libsrc/Dk
	libsrc/Thread
	libsrc/Tidy
	libsrc/Wi
	libsrc/Xml.new
	libsrc/langfunc
	libsrc/odbcsdk
	libsrc/plugin
	libsrc/util
	binsrc/virtuoso
	binsrc/tests
"

DOCS=( AUTHORS ChangeLog CREDITS INSTALL NEWS README )

PATCHES=(
	"${FILESDIR}/${PN}-6.1.4-unbundle-minizip.patch"
)

src_prepare() {
	sed -e '/^lib_LTLIBRARIES\s*=.*/s/lib_/noinst_/' -i binsrc/virtuoso/Makefile.am \
		|| die "failed to disable installation of static lib"

	virtuoso_src_prepare
}

src_configure() {
	myconf+="
		$(use_enable kerberos krb)
		$(use_enable ldap openldap)
		$(use_with readline)
		--disable-static
		--disable-hslookup
		--disable-rendezvous
		--without-iodbc
		--program-transform-name="s/isql/isql-v/"
	"

	virtuoso_src_configure
}

src_install() {
	default_src_install

	keepdir /var/lib/virtuoso/db
}
