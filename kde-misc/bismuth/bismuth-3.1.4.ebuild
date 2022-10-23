# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Tiling window management script for Kwin"
HOMEPAGE="https://github.com/Bismuth-Forge/bismuth"
SRC_URI="
	https://github.com/Bismuth-Forge/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Bismuth-Forge/bismuth/releases/download/v${PV}/binary-release.tar.gz -> ${P}-binary-release.tar.gz
"

LICENSE="CC-BY-4.0 LGPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"

QTMIN=5.15.0
KFMIN=5.78.0

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-plasma/kwin-5.24.0:5
"

RDEPEND="${DEPEND}"

RESTRICT=test # npm + js + hell + network

src_prepare() {
	# we are not building npm hell or tests
	cmake_comment_add_subdirectory tests
	cmake_run_in src cmake_comment_add_subdirectory kwinscript
	cmake_src_prepare
}

src_configuire() {
	# cmake calls git describe --tags --abbrev=0
	# let's just echo expected output, e.g. v1.2.3
	git() { echo "v${PV}" ; }
	export -f git || die

	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DUSE_NPM=OFF
		-DUSE_TSC=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/kwin/scripts
	doins -r ../share/kwin/scripts/"${PN}"
}
