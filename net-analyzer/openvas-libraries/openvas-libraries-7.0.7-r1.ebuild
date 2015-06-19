# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-libraries/openvas-libraries-7.0.7-r1.ebuild,v 1.1 2015/02/17 10:11:30 jlec Exp $

EAPI=5

inherit cmake-utils

DL_ID=1907

DESCRIPTION="A remote security scanner for Linux (openvas-libraries)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="ldap"

RDEPEND="
	app-crypt/gpgme
	>=dev-libs/glib-2.12
	dev-libs/libksba
	!net-analyzer/openvas-libnasl
	=net-libs/gnutls-2*
	net-libs/libpcap
	net-libs/libssh
	ldap? (	net-nds/openldap )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	"

DOCS="ChangeLog CHANGES README"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-libssh.patch
	"${FILESDIR}"/${PN}-7.0.4-bsdsource.patch
	"${FILESDIR}"/${PN}-7.0.4-run.patch
	"${FILESDIR}"/${PN}-7.0.6-underlinking.patch
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
