# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="breeze-icons"
PVCUT=$(ver_cut 1-2)
PYTHON_COMPAT=( python3_{9..11} )
inherit cmake frameworks.kde.org python-any-r1

DESCRIPTION="Breeze SVG icon theme binary resource"
LICENSE="LGPL-3"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	dev-qt/qtcore:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:5
	test? ( app-misc/fdupes )
"
DEPEND="test? ( dev-qt/qttest:5 )"

python_check_deps() {
	python_has_version "dev-python/lxml[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare
	use test || cmake_comment_add_subdirectory autotests
}

src_configure() {
	local mycmakeargs=(
		-DPython_EXECUTABLE="${PYTHON}"
		-DBINARY_ICONS_RESOURCE=ON
		-DSKIP_INSTALL_ICONS=ON
	)
	cmake_src_configure
}
