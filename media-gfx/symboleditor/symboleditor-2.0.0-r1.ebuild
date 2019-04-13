# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="Application to create libraries of QPainterPath objects with rendering hints"
HOMEPAGE="https://userbase.kde.org/SymbolEditor"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	MY_P=SymbolEditor-${PV}
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${MY_P}.tar.bz2"
	S="${WORKDIR}"/${MY_P}
fi

LICENSE="GPL-2"
KEYWORDS="amd64"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-doc-optional.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
	)

	kde5_src_configure
}
