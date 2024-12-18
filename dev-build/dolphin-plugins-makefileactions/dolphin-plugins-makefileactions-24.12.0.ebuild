# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="dolphin-plugins"
MY_PLUGIN_NAME="makefileactions"
PVCUT=$(ver_cut 1-3)
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Dolphin plugin for Makefile targets integration"
HOMEPAGE="https://apps.kde.org/dolphin_plugins/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,gui,widgets]
	>=kde-apps/dolphin-${PVCUT}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!<kde-apps/dolphin-plugins-subversion-24.08.2-r1
	>=kde-apps/dolphin-plugins-common-${PV}
"

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
	# solid, qtdbus only required by mountiso
	ecm_punt_qt_module DBus
	ecm_punt_kf_module Solid
	# kxmlgui, qtnetwork only required by dropbox
	ecm_punt_qt_module Network
	ecm_punt_kf_module XmlGui
	# kcompletion, ktextwidgets only required by other plugins
	ecm_punt_kf_module Completion
	ecm_punt_kf_module TextWidgets
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_${MY_PLUGIN_NAME}=ON
		-DBUILD_bazaar=OFF
		-DBUILD_dropbox=OFF
		-DBUILD_git=OFF
		-DBUILD_hg=OFF
		-DBUILD_mountiso=OFF
		-DBUILD_svn=OFF
	)
	ecm_src_configure
}
