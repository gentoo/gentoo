# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="5.1"
KDEBASE="kdevelop"
KMNAME="kdev-python"
PYTHON_COMPAT=( python3_{5,6} )
inherit kde5 python-single-r1

DESCRIPTION="Python plugin for KDevelop"
IUSE=""
[[ ${KDE_BUILD_TYPE} = release ]] && KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep threadweaver)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-util/kdevplatform:5
"
RDEPEND="${DEPEND}
	dev-util/kdevelop:5
"

RESTRICT+=" test"

pkg_setup() {
	python-single-r1_pkg_setup
	kde5_pkg_setup
}

src_compile() {
	pushd "${WORKDIR}"/${P}_build > /dev/null || die
	emake parser
	popd > /dev/null || die

	kde5_src_compile
}
