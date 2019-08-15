# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KMNAME="dolphin-plugins"
KDE_HANDBOOK="false"
MY_PLUGIN_NAME="bazaar"
inherit kde5

DESCRIPTION="Dolphin plugin for Bazaar integration"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep ktextwidgets)
	$(add_kdeapps_dep dolphin)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	!kde-apps/dolphin-plugins:5
	dev-vcs/bzr
"

src_prepare() {
	kde5_src_prepare
	# kxmlgui, qtnetwork only required by dropbox
	punt_bogus_dep Qt5 Network
	punt_bogus_dep KF5 XmlGui
	# delete non-${PN} translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -not -name "*${MY_PLUGIN_NAME}plugin" -delete || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_${MY_PLUGIN_NAME}=ON
		-DBUILD_dropbox=OFF
		-DBUILD_git=OFF
		-DBUILD_hg=OFF
		-DBUILD_svn=OFF
	)
	kde5_src_configure
}
