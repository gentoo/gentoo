# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake kde.org python-any-r1 xdg-utils

DESCRIPTION="Breeze SVG icon theme"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="test"

RESTRICT+=" !test? ( test )"

DEPEND="test? ( dev-qt/qttest:5 )"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	dev-qt/qtcore:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:5
	test? ( app-misc/fdupes )
"

python_check_deps() {
	has_version "dev-python/lxml[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}

src_configure() {
	local mycmakeargs=(
		-DPython_EXECUTABLE="${PYTHON}"
		-DBINARY_ICONS_RESOURCE=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
