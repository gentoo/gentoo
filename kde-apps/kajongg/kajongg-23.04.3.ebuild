# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PYTHON_COMPAT=( python3_{10..11} )
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit python-single-r1 ecm gear.kde.org

DESCRIPTION="Classical Mah Jongg for four players"
HOMEPAGE="https://apps.kde.org/kajongg/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~riscv x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/libkdegames-${PVCUT}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	$(python_gen_cond_dep '
		dev-python/QtPy[gui,svg,widgets,${PYTHON_USEDEP}]
		>=dev-python/twisted-16.6.0[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}
	>=kde-apps/libkmahjongg-${PVCUT}:5
"

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_prepare() {
	python_fix_shebang src
	ecm_src_prepare
}
