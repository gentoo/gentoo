# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Powerful BitTorrent client based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/internet/ktorrent/"
[[ ${KDE_BUILD_TYPE} = release ]] && SRC_URI="mirror://kde/stable/${PN}/${PV/%.0}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="+bwscheduler +downloadorder +infowidget +ipfilter +kross +logviewer +magnetgenerator
+mediaplayer rss +scanfolder +search +shutdown +stats +upnp +zeroconf"

BDEPEND="sys-devel/gettext"
COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=net-libs/libktorrent-2.1:5
	infowidget? ( dev-libs/geoip )
	kross? (
		$(add_frameworks_dep karchive)
		$(add_frameworks_dep kitemviews)
		$(add_frameworks_dep kross)
	)
	mediaplayer? (
		media-libs/phonon[qt5(+)]
		>=media-libs/taglib-1.5
	)
	rss? (
		$(add_frameworks_dep kdewebkit)
		$(add_frameworks_dep syndication)
	)
	search? (
		$(add_frameworks_dep kdewebkit)
		>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	)
	shutdown? ( $(add_plasma_dep plasma-workspace) )
	stats? ( $(add_frameworks_dep kplotting) )
	upnp? ( $(add_frameworks_dep kcompletion) )
	zeroconf? ( $(add_frameworks_dep kdnssd) )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	ipfilter? (
		app-arch/bzip2
		app-arch/unzip
		$(add_frameworks_dep ktextwidgets)
		$(add_kdeapps_dep kio-extras)
	)
"

PATCHES=(
	"${FILESDIR}/${P}-scanfolder-memcorruption.patch"
	"${FILESDIR}/${P}-kdehig.patch"
	"${FILESDIR}/${P}-singlefile-torrent.patch"
	"${FILESDIR}/${P}-kcrash.patch"
	"${FILESDIR}/${P}-missing-header.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_BWSCHEDULER_PLUGIN=$(usex bwscheduler)
		-DENABLE_DOWNLOADORDER_PLUGIN=$(usex downloadorder)
		-DENABLE_INFOWIDGET_PLUGIN=$(usex infowidget)
		-DWITH_SYSTEM_GEOIP=$(usex infowidget)
		-DENABLE_IPFILTER_PLUGIN=$(usex ipfilter)
		-DENABLE_SCRIPTING_PLUGIN=$(usex kross)
		-DENABLE_LOGVIEWER_PLUGIN=$(usex logviewer)
		-DENABLE_MAGNETGENERATOR_PLUGIN=$(usex magnetgenerator)
		-DENABLE_MEDIAPLAYER_PLUGIN=$(usex mediaplayer)
		$(cmake_use_find_package rss KF5Syndication)
		-DENABLE_SCANFOLDER_PLUGIN=$(usex scanfolder)
		-DENABLE_SEARCH_PLUGIN=$(usex search)
		-DENABLE_SHUTDOWN_PLUGIN=$(usex shutdown)
		-DENABLE_STATS_PLUGIN=$(usex stats)
		-DENABLE_UPNP_PLUGIN=$(usex upnp)
		-DENABLE_ZEROCONF_PLUGIN=$(usex zeroconf)
	)
# add back when ported
# 		-DENABLE_WEBINTERFACE_PLUGIN=$(usex webinterface)
	kde5_src_configure
}
