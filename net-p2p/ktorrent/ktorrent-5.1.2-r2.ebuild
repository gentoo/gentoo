# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="optional"
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Powerful BitTorrent client based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/internet/org.kde.ktorrent"
[[ ${KDE_BUILD_TYPE} = release ]] && SRC_URI="mirror://kde/stable/${PN}/${PV/%.0}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 arm64 ~x86"
IUSE="+bwscheduler +downloadorder +infowidget +ipfilter +kross +logviewer +magnetgenerator
+mediaplayer rss +scanfolder +search +shutdown +stats +upnp +zeroconf"

BDEPEND="sys-devel/gettext"
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=net-libs/libktorrent-2.1.1:5
	infowidget? ( dev-libs/geoip )
	kross? (
		>=kde-frameworks/karchive-${KFMIN}:5
		>=kde-frameworks/kitemviews-${KFMIN}:5
		>=kde-frameworks/kross-${KFMIN}:5
	)
	mediaplayer? (
		media-libs/phonon[qt5(+)]
		>=media-libs/taglib-1.5
	)
	rss? (
		>=kde-frameworks/kdewebkit-${KFMIN}:5
		>=kde-frameworks/syndication-${KFMIN}:5
	)
	search? (
		>=dev-qt/qtwebkit-5.212.0_pre20180120:5
		>=kde-frameworks/kdewebkit-${KFMIN}:5
	)
	shutdown? ( >=kde-plasma/plasma-workspace-5.15.5 )
	stats? ( >=kde-frameworks/kplotting-${KFMIN}:5 )
	upnp? ( >=kde-frameworks/kcompletion-${KFMIN}:5 )
	zeroconf? ( >=kde-frameworks/kdnssd-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	ipfilter? (
		app-arch/bzip2
		app-arch/unzip
		>=kde-apps/kio-extras-19.04.3
		>=kde-frameworks/ktextwidgets-${KFMIN}:5
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.1-singlefile-torrent.patch" # git master
	"${FILESDIR}/${P}-crash-on-exit.patch" # bug #632588
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
	ecm_src_configure
}
