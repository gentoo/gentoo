# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=5d8bfe4441be81ff3ced10114bb012d24ec0ab86
inherit cmake kde.org xdg-utils

DESCRIPTION="Fast heap memory profiler"
HOMEPAGE="https://apps.kde.org/heaptrack/
https://milianw.de/blog/heaptrack-a-heap-memory-profiler-for-linux"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui test zstd"

RESTRICT="!test? ( test )"

# TODO: unbundle robin-map
DEPEND="
	dev-libs/boost:=[zstd?,zlib]
	sys-libs/libunwind:=
	sys-libs/zlib
	gui? (
		dev-libs/kdiagram:6
		dev-qt/qtbase:6[gui,widgets]
		kde-frameworks/kconfig:6
		kde-frameworks/kconfigwidgets:6
		kde-frameworks/kcoreaddons:6
		kde-frameworks/ki18n:6
		kde-frameworks/kio:6
		kde-frameworks/kitemmodels:6
		kde-frameworks/kwidgetsaddons:6
		kde-frameworks/threadweaver:6
	)
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}
	gui? ( >=kde-frameworks/kf-env-4 )
"
BDEPEND="gui? ( kde-frameworks/extra-cmake-modules:0 )"

QA_CONFIG_IMPL_DECL_SKIP=(
	# This doesn't exist in libunwind (bug #898768).
	unw_backtrace_skip
)

src_prepare() {
	cmake_src_prepare
	rm -rf 3rdparty/boost-zstd || die # ensure no bundling
}

src_configure() {
	local mycmakeargs=(
		-DHEAPTRACK_USE_QT6=ON
		-DHEAPTRACK_BUILD_GUI=$(usex gui)
		-DBUILD_TESTING=$(usex test)
		$(cmake_use_find_package zstd ZSTD)
	)
	cmake_src_configure
}

pkg_postinst() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
