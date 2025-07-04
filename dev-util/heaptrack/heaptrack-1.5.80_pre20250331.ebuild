# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=0fb2eb516b5d762f202195f8f439bbf1ea463880
inherit cmake kde.org xdg

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
	use gui && xdg_pkg_postinst
}

pkg_postrm() {
	use gui && xdg_pkg_postrm
}
