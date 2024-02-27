# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
PYTHON_COMPAT=( python3_{10..12} )
inherit cmake frameworks.kde.org python-any-r1 xdg

DESCRIPTION="Breeze SVG icon theme"

LICENSE="LGPL-3"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	!kde-frameworks/${PN}:5
	!kde-frameworks/${PN}-rcc:5
	!kde-frameworks/${PN}-rcc:6
"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	dev-qt/qtbase:6
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:*
	test? ( app-misc/fdupes )
"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

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
		-DSKIP_INSTALL_ICONS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# bug 770988
	find "${ED}"/usr/share/icons/ -type d -empty -delete || die
	find "${ED}"/usr/share/icons/ -xtype l -delete || die
}
