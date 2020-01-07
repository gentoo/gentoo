# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kde.org xdg-utils

DESCRIPTION="Fast heap memory profiler"
HOMEPAGE="http://milianw.de/blog/heaptrack-a-heap-memory-profiler-for-linux"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""
IUSE="+gui test zstd"

BDEPEND="
	gui? ( kde-frameworks/extra-cmake-modules:5 )
"
DEPEND="
	dev-libs/boost:=
	sys-libs/libunwind
	sys-libs/zlib
	gui? (
		dev-libs/kdiagram:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		kde-frameworks/kconfig:5
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/ki18n:5
		kde-frameworks/kio:5
		kde-frameworks/kitemmodels:5
		kde-frameworks/kwidgetsaddons:5
		kde-frameworks/threadweaver:5
	)
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}
	gui? ( >=kde-frameworks/kf-env-4 )
"

RESTRICT+=" !test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DHEAPTRACK_BUILD_GUI=$(usex gui)
		-DBUILD_TESTING=$(usex test)
		$(cmake_use_find_package zstd Zstd)
	)
	cmake_src_configure
}

xdg_pkg_postinst() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

xdg_pkg_postrm() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
