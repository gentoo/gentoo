# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
KDE_ORG_NAME="dolphin-plugins"
MY_PLUGIN_NAME="git"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Dolphin plugin for Git integration"
HOMEPAGE="https://apps.kde.org/dolphin_plugins/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/dolphin-${PVCUT}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
"
RDEPEND="${DEPEND}
	dev-vcs/git
"

src_prepare() {
	ecm_src_prepare
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
		-DBUILD_hg=OFF
		-DBUILD_mountiso=OFF
		-DBUILD_svn=OFF
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	rm "${D}"/usr/share/metainfo/org.kde.dolphin-plugins.metainfo.xml || die
}
