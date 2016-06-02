# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

LIBKT_VERSION_MIN="${PV}"
LIBKT_VERSION_MAX="99999999"
if [[ ${PV} != 9999* ]]; then
	inherit versionator
	# upstream likes to skip that _ in beta releases
	MY_PV="${PV/_/}"
	LIBKT_VERSION_MIN=$(($(get_major_version)-3)).$(get_version_component_range 2-3 ${PV})
	LIBKT_VERSION_MAX=$(($(get_major_version)-3)).$(($(get_version_component_range 2)+1))
	MY_P="${PN}-${MY_PV}"

	SRC_URI="mirror://kde/stable/${PN}/${MY_PV}/${MY_P}.tar.xz"
	S="${WORKDIR}"/"${MY_P}"

	KEYWORDS="~amd64 ~x86"
else
	LIBKT_VERSION_MIN="${PV}"
	LIBKT_VERSION_MAX="99999999"
	KEYWORDS=""
fi

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Powerful BitTorrent client based on KDE Frameworks"
HOMEPAGE="http://ktorrent.pwsp.net/"

LICENSE="GPL-2"
IUSE="+bwscheduler +downloadorder +infowidget +logviewer
+magnetgenerator +mediaplayer +shutdown +upnp +zeroconf"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kdewebkit)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	<net-libs/libktorrent-${LIBKT_VERSION_MAX}:5
	>=net-libs/libktorrent-${LIBKT_VERSION_MIN}:5
	infowidget? ( dev-libs/geoip )
	mediaplayer? (
		media-libs/phonon[qt5]
		>=media-libs/taglib-1.5
	)
	shutdown? ( $(add_plasma_dep plasma-workspace) )
	zeroconf? ( $(add_frameworks_dep kdnssd) )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost:=
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	!net-p2p/ktorrent:4
"
# add back when ported - DEPEND
# 	kross? ( $(add_frameworks_dep kross) )
# 	rss? ( $(add_kdeapps_dep kdepimlibs) )
# add back when ported - RDEPEND
# 	ipfilter? (
# 		app-arch/bzip2
# 		app-arch/unzip
# 		$(add_kdeapps_dep kdebase-kioslaves)
# 	)
# 	kross? ( $(add_kdebase_dep krosspython) )

# src_prepare() {
# add back when ported
# 	if ! use plasma; then
# 		sed -i \
# 			-e "s:add_subdirectory(plasma):#nada:g" \
# 			CMakeLists.txt || die "Failed to make plasmoid optional"
# 	fi
#
# 	kde5_src_prepare
# }

src_prepare() {
	kde5_src_prepare

	punt_bogus_dep KF5 Kross
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_BWSCHEDULER_PLUGIN=$(usex bwscheduler)
		-DENABLE_DOWNLOADORDER_PLUGIN=$(usex downloadorder)
		-DENABLE_INFOWIDGET_PLUGIN=$(usex infowidget)
		-DWITH_SYSTEM_GEOIP=$(usex infowidget)
		-DENABLE_LOGVIEWER_PLUGIN=$(usex logviewer)
		-DENABLE_MAGNETGENERATOR_PLUGIN=$(usex magnetgenerator)
		-DENABLE_MEDIAPLAYER_PLUGIN=$(usex mediaplayer)
		-DENABLE_SHUTDOWN_PLUGIN=$(usex shutdown)
		-DENABLE_UPNP_PLUGIN=$(usex upnp)
		-DENABLE_ZEROCONF_PLUGIN=$(usex zeroconf)
	)
# add back when ported
# 		-DENABLE_IPFILTER_PLUGIN=$(usex ipfilter)
# 		-DENABLE_SCRIPTING_PLUGIN=$(usex kross)
# 		-DENABLE_SYNDICATION_PLUGIN=$(usex rss)
# 		-DENABLE_SCANFOLDER_PLUGIN=$(usex scanfolder)
# 		-DENABLE_SEARCH_PLUGIN=$(usex search)
# 		-DENABLE_STATS_PLUGIN=$(usex stats)
# 		-DENABLE_WEBINTERFACE_PLUGIN=$(usex webinterface)
	kde5_src_configure
}
