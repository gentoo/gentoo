# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
PYTHON_COMPAT=( python3_{11..13} )
KFMIN=6.13.0
QTMIN=6.8.1
inherit python-single-r1 ecm gear.kde.org xdg

DESCRIPTION="KDE Interactive Geometry tool"
HOMEPAGE="https://apps.kde.org/kig/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="scripting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	scripting? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.70:=[python,${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}
	>=kde-frameworks/ktexteditor-${KFMIN}:6
"

PATCHES=( "${FILESDIR}"/${PN}-25.07.80-cmake-boostpython.patch )

src_prepare() {
	ecm_src_prepare
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		-DBOOSTPYTHON_VERSION_MAJOR_MINOR=${EPYTHON}
		$(cmake_use_find_package scripting Boost)
	)

	ecm_src_configure
}
