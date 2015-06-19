# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kauth/kauth-5.11.0.ebuild,v 1.1 2015/06/15 18:35:11 kensington Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework to let applications perform actions as a privileged user"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="nls +policykit"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	policykit? ( sys-auth/polkit-qt[qt5] )
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
"
# Plasma is still masked
#PDEPEND="policykit? ( kde-plasma/polkit-kde-agent )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package policykit PolkitQt-1)
	)

	kde5_src_configure
}
