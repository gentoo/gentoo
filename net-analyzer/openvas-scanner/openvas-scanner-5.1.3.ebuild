# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=openvassd
inherit cmake-utils git-r3 systemd

DESCRIPTION="A remote security scanner for Linux (OpenVAS-scanner)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/greenbone/openvas-scanner.git"
EGIT_BRANCH="openvas-scanner-5.1"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+extras"

DEPEND=">=net-analyzer/openvas-libraries-9.0.3"

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
	insinto /etc/openvas
	doins "${FILESDIR}"/${MY_PN}.conf "${FILESDIR}"/redis.conf.example

	insinto /etc/openvas/sysconfig
	doins"${FILESDIR}"/${MY_PN}-daemon.conf

	insinto /etc/openvas/scripts
	doins "${FILESDIR}"/openvas-feed-sync "${FILESDIR}"/first-start
	fperms 0755 /etc/openvas/scripts/openvas-feed-sync /etc/openvas/scripts/first-start

	newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}
	newconfd "${FILESDIR}"/${MY_PN}-daemon.conf ${MY_PN}

	insinto /etc/logrotate.d
	doins "${FILESDIR}"/${MY_PN}.logrotate

	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}
