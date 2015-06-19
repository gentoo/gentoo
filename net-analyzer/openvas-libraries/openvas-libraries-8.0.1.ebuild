# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-libraries/openvas-libraries-8.0.1.ebuild,v 1.1 2015/04/06 10:33:54 jlec Exp $

EAPI=5

inherit cmake-utils

DL_ID=2015

DESCRIPTION="A remote security scanner for Linux (openvas-libraries)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="ldap"

RDEPEND="
	app-crypt/gpgme
	>=dev-libs/glib-2.16
	>=dev-libs/hiredis-0.10.1
	dev-libs/libgcrypt:0
	dev-libs/libksba
	!net-analyzer/openvas-libnasl
	=net-libs/gnutls-2*
	net-libs/libpcap
	>=net-libs/libssh-0.5.0
	net-analyzer/net-snmp
	ldap? (	net-nds/openldap )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	"

S="${WORKDIR}"/${P/_beta/+beta}

DOCS=( ChangeLog CHANGES README )

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-libssh.patch
	"${FILESDIR}"/${P}-include.patch
	)

src_prepare() {
	sed \
		-e '/^install.*OPENVAS_CACHE_DIR.*/d' \
		-i CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		$(usex ldap -DBUILD_WITHOUT_LDAP=0 -DBUILD_WITHOUT_LDAP=1)
	)
	cmake-utils_src_configure
}
