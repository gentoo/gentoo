# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="false"
KDE_ORG_NAME="dolphin-plugins"
MY_PLUGIN_NAME="hg"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Dolphin plugin for Mercurial integration"
HOMEPAGE="https://kde.org/applications/system/org.kde.dolphin_plugins"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-apps/dolphin-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/dolphin-plugins:5
	dev-vcs/mercurial
"

src_prepare() {
	ecm_src_prepare
	# kxmlgui, qtnetwork only required by dropbox
	ecm_punt_bogus_dep Qt5 Network
	ecm_punt_bogus_dep KF5 XmlGui
	# delete non-${PN} translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -not -name "*${MY_PLUGIN_NAME}plugin" -delete || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_${MY_PLUGIN_NAME}=ON
		-DBUILD_bazaar=OFF
		-DBUILD_dropbox=OFF
		-DBUILD_git=OFF
		-DBUILD_svn=OFF
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install
	rm "${D}"/usr/share/metainfo/org.kde.dolphin-plugins.metainfo.xml || die
}
