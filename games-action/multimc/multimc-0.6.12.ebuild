# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2 xdg cmake

MY_PN="MultiMC5"
MY_P="${MY_PN}-${PV}"

QUAZIP_VER="multimc-3"
LIBNBTPLUSPLUS_VER="multimc-0.6.1"

DESCRIPTION="An advanced Qt5-based open-source launcher for Minecraft"
HOMEPAGE="https://multimc.org
	https://github.com/MultiMC/MultiMC5"
BASE_URI="https://github.com/MultiMC"
SRC_URI="
	${BASE_URI}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${BASE_URI}/libnbtplusplus/archive/${LIBNBTPLUSPLUS_VER}.tar.gz -> libnbtplusplus-${LIBNBTPLUSPLUS_VER}.tar.gz
	${BASE_URI}/quazip/archive/${QUAZIP_VER}.tar.gz -> quazip-${QUAZIP_VER}.tar.gz
"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

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
	>=virtual/jdk-1.8.0
"
RDEPEND="${COMMON_DEPEND}
	sys-libs/zlib
	>=virtual/jre-1.8.0
	virtual/opengl
	x11-libs/libXrandr
"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}"/multimc-0.6.12-gcc11.patch )

src_unpack() {
	default
	rm -rf "${S}/libraries/libnbtplusplus" "${S}/libraries/quazip" || die
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
	domenu application/package/linux/multimc.desktop
	doicon -s scalable application/resources/multimc/scalable/multimc.svg
}
