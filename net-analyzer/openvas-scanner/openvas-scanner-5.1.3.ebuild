# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils systemd
MY_PN="openvas-scanner"

DESCRIPTION="A remote security scanner for Linux (OpenVAS-scanner)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

DEPEND="
	dev-db/redis
	dev-libs/libgcrypt:0=
	>=net-analyzer/openvas-libraries-9.0.3
	net-libs/gnutls:=[tools]
	net-libs/libssh:=
	extras? ( dev-perl/CGI )"

RDEPEND="
	${DEPEND}
	!net-analyzer/openvas-tools"

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
	"${FILESDIR}/${P}-nvt.patch"
	"${FILESDIR}/${P}-cachedir.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	# Fix for correct FHS/Gentoo policy paths for 5.1.3
	sed -i "s*/doc/openvas-scanner/*/doc/openvas-scanner-${PV}/*g" "$S"/CMakeLists.txt || die
	if use extras; then
		doxygen -u "$S"/doc/Doxyfile_full.in || die
	fi
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
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

	insinto /etc/openvas
	doins "${FILESDIR}"/openvassd.conf "${FILESDIR}"/redis.conf.example

	insinto /etc/openvas/sysconfig
	doins "${FILESDIR}"/${MY_PN}-daemon.conf

	insinto /etc/openvas/scripts
	doins "${FILESDIR}"/openvas-feed-sync "${FILESDIR}"/first-start
	fperms 0755 /etc/openvas/scripts/{openvas-feed-sync,first-start}

	newinitd "${FILESDIR}/${MY_PN}.init" ${MY_PN}
	newconfd "${FILESDIR}/${MY_PN}-daemon.conf" ${MY_PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate" ${MY_PN}

	systemd_newtmpfilesd "${FILESDIR}/${MY_PN}.tmpfiles.d" ${MY_PN}.conf
	systemd_dounit "${FILESDIR}"/${MY_PN}.service

	keepdir /var/lib/openvas/plugins
}
