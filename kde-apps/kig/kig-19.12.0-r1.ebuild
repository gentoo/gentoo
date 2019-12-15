# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
PYTHON_COMPAT=( python3_{6,7,8} )
KFMIN=5.63.0
QTMIN=5.12.3
inherit python-single-r1 ecm kde.org

DESCRIPTION="KDE Interactive Geometry tool"
HOMEPAGE="https://kde.org/applications/education/org.kde.kig
https://edu.kde.org/kig/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="geogebra scripting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	geogebra? ( >=dev-qt/qtxmlpatterns-${QTMIN}:5 )
	scripting? ( >=dev-libs/boost-1.48:=[python,${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=kde-frameworks/ktexteditor-${KFMIN}:5
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.12.0-boostpython.patch
	"${FILESDIR}"/${PN}-19.08.3-pykig-python3.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_prepare() {
	ecm_src_prepare
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package geogebra Qt5XmlPatterns)
		$(cmake_use_find_package scripting BoostPython)
	)

	ecm_src_configure
}
