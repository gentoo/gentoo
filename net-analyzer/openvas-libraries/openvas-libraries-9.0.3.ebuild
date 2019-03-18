# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils
MY_PN="gvm-libs"

DESCRIPTION="A remote security scanner for Linux (openvas-libraries)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="extras ldap radius"

DEPEND="
	app-crypt/gpgme:=
	dev-libs/hiredis
	dev-libs/libgcrypt:0=
	dev-libs/libksba
	dev-perl/UUID
	net-analyzer/net-snmp
	net-libs/gnutls:=[tools]
	net-libs/libpcap
	net-libs/libssh:=
	sys-libs/zlib
	extras? ( dev-perl/CGI )
	ldap? ( net-nds/openldap )
	radius? ( net-dialup/freeradius-client )"

RDEPEND="
	${DEPEND}"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	extras? ( app-doc/doxygen[dot]
		  app-doc/xmltoman
		  app-text/htmldoc
		  dev-perl/SQL-Translator
	)"

PATCHES=(
	"${FILESDIR}/${P}-gcc8.patch"
	"${FILESDIR}/${P}-netsnmp.patch"
	"${FILESDIR}/${P}-cachedir.patch"
	"${FILESDIR}/${P}-rundir.patch"
	"${FILESDIR}/${P}-underlinking.patch"
	"${FILESDIR}/${P}-rpath.patch"
)

BUILD_DIR="${WORKDIR}/${MY_PN}-${PV}_build"
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cmake-utils_src_prepare
	if use extras; then
		doxygen -u "$S"/doc/Doxyfile_full.in || die
	fi
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		$(usex ldap -DBUILD_WITHOUT_LDAP=0 -DBUILD_WITHOUT_LDAP=1)
		$(usex radius -DBUILD_WITHOUT_RADIUS=0 -DBUILD_WITHOUT_RADIUS=1)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use extras; then
		cmake-utils_src_make -C "${BUILD_DIR}" doc
		cmake-utils_src_make doc-full -C "${BUILD_DIR}" doc
		HTML_DOCS=( "${BUILD_DIR}"/doc/generated/html/. )
	fi
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/openvas
	doins "${FILESDIR}"/OPENVAS.gentoo

	keepdir /var/lib/openvas/gnupg
	keepdir /var/log/openvas
}
