# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="A frontend to the subversion vcs"
HOMEPAGE="https://kde.org/applications/development/org.kde.kdesvn"

if [[ ${PV} != 9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
IUSE="+man"

BDEPEND="
	man? ( $(add_frameworks_dep kdoctools) )
"
DEPEND="
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/apr:1
	dev-libs/apr-util:1
	dev-vcs/subversion
"
RDEPEND="${DEPEND}
	!kde-apps/kdesdk-kioslaves:4[subversion(-)]
"

src_prepare(){
	kde5_src_prepare

	if ! use man ; then
		sed -i -e "/kdoctools_create_manpage/ s/^/#/" doc/CMakeLists.txt || die
	fi
}
