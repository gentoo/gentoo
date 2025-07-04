# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="KDE library for mathematical features"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="amd64 arm64 ~riscv ~x86"
IUSE="eigen"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[-gles2-only,gui,opengl,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	eigen? ( dev-cpp/eigen:3 )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

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
