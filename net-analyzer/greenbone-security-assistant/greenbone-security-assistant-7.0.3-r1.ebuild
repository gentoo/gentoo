# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils systemd
MY_PN="gsa"

DESCRIPTION="Greenbone Security Assistant for OpenVAS"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+ BSD MIT"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=net-analyzer/openvas-libraries-9.0.3
	net-libs/gnutls:=[tools]
	net-libs/libmicrohttpd[messages]
	extras? ( dev-python/polib )"

RDEPEND="
	${DEPEND}
	>=net-analyzer/openvas-scanner-5.1.3
	>=net-analyzer/openvas-manager-7.0.3
	extras? ( dev-texlive/texlive-latexextra )"

BDEPEND="
	virtual/pkgconfig
	extras? ( app-doc/doxygen[dot]
		  app-doc/xmltoman
		  app-text/htmldoc
		  sys-devel/gettext
	)"

BUILD_DIR="${WORKDIR}/${MY_PN}-${PV}_build"
S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-memleak.patch"
	"${FILESDIR}/${P}-auth.patch"
)

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

	insinto /etc/openvas/sysconfig
	doins "${FILESDIR}"/${MY_PN}-daemon.conf

	insinto /etc/openvas/reverse-proxy
	doins "${FILESDIR}"/gsa.nginx.reverse.proxy.example

	newinitd "${FILESDIR}/${MY_PN}.init" ${MY_PN}
	newconfd "${FILESDIR}/${MY_PN}-daemon.conf" ${MY_PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate" ${MY_PN}

	systemd_newtmpfilesd "${FILESDIR}/${MY_PN}.tmpfiles.d" ${MY_PN}.conf
	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}
