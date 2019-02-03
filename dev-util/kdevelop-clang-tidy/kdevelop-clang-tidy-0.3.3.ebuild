# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDEBASE="kdevelop"
KDE_TEST="true"
KMNAME="kdev-clang-tidy"
VIRTUALX_REQUIRED="test"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN/kdevelop/kdev}/${PV}/src/${P/kdevelop/kdev}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="KDevelop plugin for clang-tidy static analysis support"
LICENSE="GPL-2+"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	>=dev-util/kdevelop-5.2.3:5
"
RDEPEND="${COMMON_DEPEND}
	sys-devel/clang:*
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	dev-util/kdevelop:5[test?]
"

src_prepare() {
	kde5_src_prepare
	# drop when upstream depends on >=kdevelop-5.2.2
	sed -e "/KF_ADDITIONAL_REQ_COMPONENTS/d" -i CMakeLists.txt
}
