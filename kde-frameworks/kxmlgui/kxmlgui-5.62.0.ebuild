# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_DESIGNERPLUGIN="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for managing menu and toolbar actions in an abstract way"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="LGPL-2+"
IUSE="attica"

# slot op: includes QtCore/private/qlocale_p.h
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtcore '' '' '5=')
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork 'ssl')
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	attica? ( $(add_frameworks_dep attica) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package attica KF5Attica)
	)

	kde5_src_configure
}

src_test() {
	# Files are missing; whatever. Bugs 650290, 668198
	local myctestargs=(
		-E "(ktoolbar_unittest|kxmlgui_unittest)"
	)

	kde5_src_test
}
