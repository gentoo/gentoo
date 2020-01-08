# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_DOC_DIR="docs"
KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
KMNAME="kdev-php"
VIRTUALX_REQUIRED="test"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="PHP plugin for KDevelop"
HOMEPAGE="https://www.kdevelop.org/"
LICENSE="GPL-2 LGPL-2"
IUSE=""

BDEPEND="
	test? ( dev-util/kdevelop:5[test] )
"
DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep threadweaver)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-util/kdevelop-pg-qt:5
	dev-util/kdevelop:5=
"
RDEPEND="${DEPEND}"

# remaining tests fail for some, bug 668530
RESTRICT+=" test"

src_test() {
	# tests hang, bug 667922
	local myctestargs=(
		-E "(completionbenchmark|duchain_multiplefiles)"
	)
	kde5_src_test
}
