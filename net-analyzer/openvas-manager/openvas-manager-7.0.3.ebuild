# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils flag-o-matic systemd
MY_PN="gvmd"

DESCRIPTION="A remote security manager for Linux (openvas-manager)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

DEPEND="
	dev-db/sqlite:3
	dev-libs/libgcrypt:0=
	>=net-analyzer/openvas-libraries-9.0.3
	extras? ( dev-perl/CGI
		  dev-perl/GD
		  media-libs/gd:2=
	)"

RDEPEND="
	${DEPEND}
	>=net-analyzer/openvas-scanner-5.1.3"

BDEPEND="
	virtual/pkgconfig
	extras? ( app-doc/doxygen[dot]
		  app-doc/xmltoman
		  app-text/htmldoc
		  dev-perl/SQL-Translator
	)"

BUILD_DIR="${WORKDIR}/${MY_PN}-${PV}_build"
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cmake-utils_src_prepare
	# Fix the ebuild to use correct FHS/Gentoo policy paths for 7.0.3
	sed -i "s*/doc/openvas-manager/html/*/doc/openvas-manager-${PV}/html/*g" "$S"/doc/CMakeLists.txt || die
	sed -i "s*/doc/openvas-manager/*/doc/openvas-manager-${PV}/*g" "$S"/CMakeLists.txt || die
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
	# Fix runtime QA error for 7.0.3
	append-cflags -Wno-nonnull
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

	insinto /etc/openvas/sysconfig
	doins "${FILESDIR}"/${MY_PN}-daemon.conf

	newinitd "${FILESDIR}/${MY_PN}.init" ${MY_PN}
	newconfd "${FILESDIR}/${MY_PN}-daemon.conf" ${MY_PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate" ${MY_PN}

	systemd_dounit "${FILESDIR}"/${MY_PN}.service

	keepdir /var/lib/openvas/openvasmd
}
