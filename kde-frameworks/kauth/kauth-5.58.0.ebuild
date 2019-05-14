# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework to let applications perform actions as a privileged user"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls +policykit"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	policykit? ( sys-auth/polkit-qt[qt5(+)] )
"
RDEPEND="${DEPEND}"
PDEPEND="policykit? ( kde-plasma/polkit-kde-agent )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package policykit PolkitQt5-1)
	)

	kde5_src_configure
}

src_test() {
	# KAuthHelperTest test fails, bug 654842
	local myctestargs=(
		-E "(KAuthHelperTest)"
	)

	kde5_src_test
}
