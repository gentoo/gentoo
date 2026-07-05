# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_EXAMPLES="true"
ECM_TEST="true"
KFMIN=6.26.0
QTMIN=6.10.1
inherit ecm plasma.kde.org

DESCRIPTION="Style engine providing a unified style description to separate output styles"
HOMEPAGE="https://quantumproductions.info/articles/2025-02/moving-kdes-styling-future
https://files.quantumproductions.info/union/overview.html"

LICENSE="|| ( LGPL-2.1 LGPL-3 ) GPL-3 BSD-2"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE="tools widgets"

# IUSE="svg"
# 	svg? (
# 		>=dev-cpp/rapidyaml-0.7.2:=
# 		>=dev-qt/qtsvg-${QTMIN}:6
# 		>=kde-frameworks/karchive-${KFMIN}:6
# 		>=kde-frameworks/kcolorscheme-${KFMIN}:6
# 		>=kde-frameworks/kconfig-${KFMIN}:6
# 		kde-plasma/libplasma:6=
# 	)
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets?]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtshadertools-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
"
RDEPEND="${DEPEND}
	dev-libs/cxx-rust-cssparser
	widgets? ( kde-plasma/breeze:6 )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[qdoc]"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_INPUT_PLASMASVG=OFF # defunct as of 2025-10-09
		-DBUILD_INPUT_CSS=ON # CSS is the default input format
		-DBUILD_WITH_KDEFRAMEWORKS=ON # required by BUILD_PLATFORM_PLASMA
		-DBUILD_PLATFORM_PLASMA=ON
		-DBUILD_OUTPUT_KIRIGAMI=ON
		-DBUILD_OUTPUT_QTQUICK=ON # required by BUILD_OUTPUT_KIRIGAMI
		-DBUILD_OUTPUT_QTWIDGETS=$(usex widgets)
		-DBUILD_TOOLS=$(usex tools)
	)
	ecm_src_configure
}

src_install() {
	use examples && local DOCS+=( "${S}"/examples/snippets/{Button,Positioner}.qml )
	use tools && dobin "${BUILD_DIR}"/bin/union-ruleinspector
	ecm_src_install
}
