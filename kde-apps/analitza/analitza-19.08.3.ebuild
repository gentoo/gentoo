# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional-recursive"
VIRTUALX_REQUIRED="test"
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE library for mathematical features"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="eigen nls"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[-gles2]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	eigen? ( dev-cpp/eigen:3 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare

	if ! use test; then
		sed -i \
			-e "/add_subdirectory(examples)/ s/^/#DONT/" \
			analitzaplot/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package eigen Eigen3)
	)

	ecm_src_configure
}
