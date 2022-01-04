# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 xdg cmake

QUAZIP_VER="multimc-3"
LIBNBTPLUSPLUS_VER="multimc-0.6.1"

DESCRIPTION="An advanced Qt5-based open-source launcher for Minecraft"
HOMEPAGE="https://multimc.org
	https://github.com/MultiMC/Launcher"
BASE_URI="https://github.com/MultiMC"
SRC_URI="
	${BASE_URI}/Launcher/archive/${PV}.tar.gz -> ${P}.tar.gz
	${BASE_URI}/libnbtplusplus/archive/${LIBNBTPLUSPLUS_VER}.tar.gz -> libnbtplusplus-${LIBNBTPLUSPLUS_VER}.tar.gz
	${BASE_URI}/quazip/archive/${QUAZIP_VER}.tar.gz -> quazip-${QUAZIP_VER}.tar.gz
"
S="${WORKDIR}/MultiMC5-${PV}"

KEYWORDS="~amd64"
LICENSE="Apache-2.0 Boost-1.0 BSD-2 BSD GPL-2+ LGPL-2.1-with-linking-exception LGPL-3 OFL-1.1 MIT"
SLOT="0"

# Author has indicated that he is unhappy with redistributing custom builds
# under the MultiMC name/logo
# https://github.com/MultiMC/Launcher/issues/4087
RESTRICT="bindist"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtxml:5
"
DEPEND="${COMMON_DEPEND}
	virtual/jdk:1.8
"
RDEPEND="${COMMON_DEPEND}
	sys-libs/zlib
	>=virtual/jre-1.8:*
	virtual/opengl
	x11-libs/libXrandr
"

src_unpack() {
	default
	rm -r "${S}/libraries/libnbtplusplus" "${S}/libraries/quazip" || die
	mv "${WORKDIR}/libnbtplusplus-${LIBNBTPLUSPLUS_VER}" "${S}/libraries/libnbtplusplus" || die
	mv "${WORKDIR}/quazip-${QUAZIP_VER}" "${S}/libraries/quazip" || die
}

src_prepare() {
	cmake_src_prepare
	sed -r -i 's/-Werror([a-z=-]+)?//g' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DMultiMC_LAYOUT=lin-system
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	domenu launcher/package/linux/multimc.desktop
	doicon -s scalable launcher/resources/multimc/scalable/multimc.svg
}

pkg_postinst() {
	xdg_pkg_postinst
	elog ""
	elog "In order to use Microsoft accounts instead of Mojang accounts"
	elog "either use the official binary packaged in games-action/multimc-bin,"
	elog "or patch your own secret API key into the MSAClientID variable in"
	elog "notsecrets/Secrets.cpp."
	elog "See Also: https://bugs.gentoo.org/814404"
	elog ""
}
