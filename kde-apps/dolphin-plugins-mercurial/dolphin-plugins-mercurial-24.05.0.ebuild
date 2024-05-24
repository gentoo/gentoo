# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
KDE_ORG_NAME="dolphin-plugins"
MY_PLUGIN_NAME="hg"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Dolphin plugin for Mercurial integration"
HOMEPAGE="https://apps.kde.org/dolphin_plugins/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-apps/dolphin-${PVCUT}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
"
RDEPEND="${DEPEND}
	dev-vcs/mercurial
"

src_prepare() {
	ecm_src_prepare
	# qtconcurrent only required by git
	ecm_punt_qt_module Concurrent
	# solid, qtdbus only required by mountiso
	ecm_punt_qt_module DBus
	ecm_punt_kf_module Solid
	# kxmlgui, qtnetwork only required by dropbox
	ecm_punt_qt_module Network
	ecm_punt_kf_module XmlGui
	# delete non-${PN} translations
	find po -type f -name "*po" -and -not -name "*${MY_PLUGIN_NAME}plugin" -delete || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_${MY_PLUGIN_NAME}=ON
		-DBUILD_bazaar=OFF
		-DBUILD_dropbox=OFF
		-DBUILD_git=OFF
		-DBUILD_makefileactions=OFF
		-DBUILD_mountiso=OFF
		-DBUILD_svn=OFF
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	rm "${D}"/usr/share/metainfo/org.kde.dolphin-plugins.metainfo.xml || die
}
