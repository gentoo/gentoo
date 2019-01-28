# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=openvasmd
inherit cmake-utils git-r3 systemd

DESCRIPTION="A remote security manager for Linux (openvas-manager)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/greenbone/gvmd.git"
EGIT_BRANCH="openvas-manager-7.0"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

DEPEND="
	>=dev-db/sqlite-3
	extras? ( media-libs/gd
		dev-perl/GD
		)
	>=net-analyzer/openvas-libraries-9.0.3
"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

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

	insinto /etc/openvas/sysconfig
	doins "${FILESDIR}"/${MY_PN}-daemon.conf

	newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}
	newconfd "${FILESDIR}"/${MY_PN}-daemon.conf ${MY_PN}

	insinto /etc/logrotate.d
	doins "${FILESDIR}"/${MY_PN}.logrotate

	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}
