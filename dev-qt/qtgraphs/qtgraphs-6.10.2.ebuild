# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Graphs component library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="quick3d"

# note: widgets is only used with quick3d and is technically optional,
# but the top level CMakeLists.txt requires through assertTargets()
RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,widgets]
	~dev-qt/qtdeclarative-${PV}:6
	quick3d? ( ~dev-qt/qtquick3d-${PV}:6 )
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# hangs+timeout with offscreen rendering
	tst_qgqmltest
)

src_configure() {
	local mycmakeargs=(
		# simpler than keeping track of and disabling every graphs-3d* features
		$(cmake_use_find_package quick3d Qt6Quick3D)
	)

	cmake_src_configure
}
