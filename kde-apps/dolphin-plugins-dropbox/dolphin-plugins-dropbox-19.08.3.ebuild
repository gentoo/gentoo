# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_ORG_NAME="dolphin-plugins"
ECM_HANDBOOK="false"
MY_PLUGIN_NAME="dropbox"
PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Dolphin plugin for Dropbox service integration"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-apps/dolphin-${PVCUT}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
"
RDEPEND="${DEPEND}
	!kde-apps/dolphin-plugins:5
	net-misc/dropbox-cli
"

src_prepare() {
	ecm_src_prepare
	# delete non-${PN} translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -not -name "*${MY_PLUGIN_NAME}plugin" -delete || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_${MY_PLUGIN_NAME}=ON
		-DBUILD_bazaar=OFF
		-DBUILD_git=OFF
		-DBUILD_hg=OFF
		-DBUILD_svn=OFF
	)
	ecm_src_configure
}
