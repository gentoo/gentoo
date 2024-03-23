# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="breeze-icons"
PVCUT=$(ver_cut 1-2)
PYTHON_COMPAT=( python3_{10..12} )
inherit cmake frameworks.kde.org python-any-r1

DESCRIPTION="Breeze SVG icon theme binary resource"
LICENSE="LGPL-3"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-qt/qttest:5 )"
BDEPEND="${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	dev-qt/qtcore:5
	>=kde-frameworks/extra-cmake-modules-${PVCUT}:0
	test? ( app-misc/fdupes )
"

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

src_install() {
	cmake_src_install

	# provided by kde-frameworks/breeze-icons
	rm -rv "${ED}"/usr/$(get_libdir)/cmake/KF5BreezeIcons || die
}
