# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DL_ID=2191
inherit cmake-utils

DESCRIPTION="A remote security scanner for Linux (openvas-libraries)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="ldap"

DEPEND="
	app-crypt/gpgme
	>=dev-libs/glib-2.16
	>=dev-libs/hiredis-0.10.1
	dev-libs/libgcrypt:0
	dev-libs/libksba
	net-analyzer/net-snmp
	net-libs/gnutls
	net-libs/libpcap
	>=net-libs/libssh-0.5.0
	ldap? (	net-nds/openldap )
"
RDEPEND="${DEPEND}
	!net-analyzer/openvas-libnasl
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

S="${WORKDIR}"/${P}

DOCS=( ChangeLog CHANGES README )

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-libssh.patch
	"${FILESDIR}"/${PN}-8.0.1-include.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e '/^install.*OPENVAS_CACHE_DIR.*/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		$(usex ldap -DBUILD_WITHOUT_LDAP=0 -DBUILD_WITHOUT_LDAP=1)
	)
	cmake-utils_src_configure
}
