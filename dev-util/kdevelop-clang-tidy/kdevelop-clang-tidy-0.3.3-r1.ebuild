# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
KMNAME="kdev-clang-tidy"
VIRTUALX_REQUIRED="test"
inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KMNAME}/${PV}/src/${KMNAME}-${PV}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="KDevelop plugin for clang-tidy static analysis support"
HOMEPAGE="https://www.kdevelop.org/"
LICENSE="GPL-2+"
IUSE=""

BDEPEND="
	dev-util/kdevelop:5[test?]
"
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
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	sys-devel/clang:*
"

src_prepare() {
	kde5_src_prepare
	sed -e "/KF_ADDITIONAL_REQ_COMPONENTS/d" -i CMakeLists.txt || die
}
