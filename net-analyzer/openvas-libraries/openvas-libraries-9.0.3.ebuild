# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake-utils git-r3

DESCRIPTION="A remote security scanner for Linux (openvas-libraries)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/greenbone/gvm-libs.git"
EGIT_BRANCH="openvas-libraries-9.0"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="extras ldap radius wmi"

DEPEND="
	>=app-crypt/gpgme-1.1.2
	dev-perl/UUID
	sys-libs/zlib
	>=dev-libs/glib-2.32
	>=dev-libs/hiredis-0.10.1
	>=dev-libs/libgcrypt-1.6
	>=dev-libs/libksba-1.0.7
	net-analyzer/net-snmp
	>=net-libs/gnutls-3.2.15[tools]
	net-libs/libpcap
	>=net-libs/libssh-0.5.0
	radius? ( net-dialup/freeradius-client )
	ldap? ( net-nds/openldap )
	wmi? ( >=net-analyzer/openvas-smb-1.0.4[extras] )
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

DOCS=( ChangeLog CHANGES README )

src_prepare() {
	cmake-utils_src_prepare
	if use extras; then
	doxygen -u "$S"/doc/Doxyfile_full.in
	fi
}

src_configure() {
	local mycmakeargs=(
	"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
	"-DLOCALSTATEDIR=${EPREFIX}/var"
	"-DSYSCONFDIR=${EPREFIX}/etc"
		$(usex ldap-vas -DBUILD_WITHOUT_LDAP=0 -DBUILD_WITHOUT_LDAP=1)
		$(usex radius-vas -DBUILD_WITHOUT_RADIUS=0 -DBUILD_WITHOUT_RADIUS=1)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use extras; then
	cmake-utils_src_make -C "${BUILD_DIR}" doc
	einfo "It seems everything is going well."
	einfo "Starting a full doc compile this will take some time."
	cmake-utils_src_make doc-full -C "${BUILD_DIR}" doc
	fi
}

src_install() {
	cmake-utils_src_install
}
