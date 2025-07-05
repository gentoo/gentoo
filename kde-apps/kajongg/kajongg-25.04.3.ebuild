# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
PYTHON_COMPAT=( python3_{10..13} )
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
inherit python-single-r1 ecm gear.kde.org xdg

DESCRIPTION="Classical Mah Jongg for four players"
HOMEPAGE="https://apps.kde.org/kajongg/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-apps/libkdegames-${PVCUT}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	|| ( dev-python/qtpy[pyqt6] dev-python/qtpy[pyside6] )
	$(python_gen_cond_dep '
		dev-python/qtpy[gui,svg,widgets,${PYTHON_USEDEP}]
		>=dev-python/twisted-16.6.0[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}
	>=kde-apps/libkmahjongg-${PVCUT}:6
"

src_prepare() {
	python_fix_shebang src
	ecm_src_prepare
}
