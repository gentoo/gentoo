# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Powerful BitTorrent client based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/ktorrent/"

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="+bwscheduler +downloadorder +infowidget +ipfilter +logviewer +magnetgenerator
+mediaplayer rss +scanfolder +shutdown +stats +upnp +webengine +zeroconf"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=net-libs/libktorrent-${PVCUT}:6
	infowidget? ( dev-libs/geoip )
	ipfilter? ( >=kde-frameworks/karchive-${KFMIN}:6 )
	mediaplayer? (
		>=media-libs/phonon-4.12.0[qt6]
		>=media-libs/taglib-1.5:=
	)
	rss? (
		>=dev-qt/qtwebengine-${QTMIN}:6
		>=kde-frameworks/syndication-${KFMIN}:6
	)
	stats? ( >=kde-frameworks/kplotting-${KFMIN}:6 )
	upnp? ( >=kde-frameworks/kcompletion-${KFMIN}:6 )
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6 )
	zeroconf? ( >=kde-frameworks/kdnssd-${KFMIN}:6 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.71
"
RDEPEND="${COMMON_DEPEND}
	ipfilter? (
		app-arch/bzip2
		app-arch/unzip
		kde-apps/kio-extras:6
		>=kde-frameworks/ktextwidgets-${KFMIN}:6
	)
"
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BWSCHEDULER_PLUGIN=$(usex bwscheduler)
		-DENABLE_DOWNLOADORDER_PLUGIN=$(usex downloadorder)
		-DENABLE_INFOWIDGET_PLUGIN=$(usex infowidget)
		-DENABLE_IPFILTER_PLUGIN=$(usex ipfilter)
		-DENABLE_LOGVIEWER_PLUGIN=$(usex logviewer)
		-DENABLE_MAGNETGENERATOR_PLUGIN=$(usex magnetgenerator)
		-DENABLE_MEDIAPLAYER_PLUGIN=$(usex mediaplayer)
		$(cmake_use_find_package rss KF6Syndication)
		-DENABLE_SCANFOLDER_PLUGIN=$(usex scanfolder)
		-DENABLE_SHUTDOWN_PLUGIN=$(usex shutdown)
		-DENABLE_STATS_PLUGIN=$(usex stats)
		-DENABLE_UPNP_PLUGIN=$(usex upnp)
		-DENABLE_SEARCH_PLUGIN=$(usex webengine)
		-DENABLE_ZEROCONF_PLUGIN=$(usex zeroconf)
	)
# add back when ported
# 		-DENABLE_WEBINTERFACE_PLUGIN=$(usex webinterface)
	ecm_src_configure
}
