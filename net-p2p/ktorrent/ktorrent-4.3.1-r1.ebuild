# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_SCM="git"
LIBKT_VERSION_MIN="${PV}"
LIBKT_VERSION_MAX="99999999"
if [[ ${PV} != 9999* ]]; then
	inherit versionator
	# upstream likes to skip that _ in beta releases
	MY_PV="${PV/_/}"
	LIBKT_VERSION_MIN=$(($(get_major_version)-3)).$(get_version_component_range 2-3 ${PV})
	LIBKT_VERSION_MAX=$(($(get_major_version)-3)).$(($(get_version_component_range 2)+1))
	MY_P="${PN}-${MY_PV}"
	KDE_HANDBOOK="optional"
	KDE_DOC_DIRS="doc"

	KDE_LINGUAS="ar ast be bg bs ca ca@valencia cs da de el en_GB eo es et eu
		fi fr ga gl hi hne hr hu is it ja km ku lt lv mai ms nb nds nl nn oc
		pl pt pt_BR ro ru se si sk sl sq sr sr@ijekavian sr@ijekavianlatin
		sr@latin sv tr ug uk zh_CN zh_TW"
	SRC_URI="http://ktorrent.org/downloads/${MY_PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}"/"${MY_P}"

	KEYWORDS="amd64 x86"
else
	LIBKT_VERSION_MIN="${PV}"
	LIBKT_VERSION_MAX="99999999"
	KEYWORDS=""
fi

inherit kde4-base

DESCRIPTION="A BitTorrent program for KDE"
HOMEPAGE="http://ktorrent.pwsp.net/"

LICENSE="GPL-2"
SLOT="4"
IUSE="+bwscheduler debug +downloadorder +infowidget +ipfilter +kross +logviewer
+magnetgenerator +mediaplayer plasma rss +scanfolder +search +shutdown +stats
+upnp webinterface +zeroconf"

COMMONDEPEND="
	<net-libs/libktorrent-${LIBKT_VERSION_MAX}:4
	>=net-libs/libktorrent-${LIBKT_VERSION_MIN}:4
	infowidget? ( dev-libs/geoip )
	mediaplayer? ( >=media-libs/taglib-1.5 )
	plasma? ( $(add_kdebase_dep libtaskmanager) )
	rss? ( $(add_kdeapps_dep kdepimlibs) )
	search? (
		|| ( $(add_kdebase_dep kdelibs webkit 4.14.22) <kde-base/kdelibs-4.14.22 )
		dev-qt/qtwebkit:4
	)
	shutdown? ( $(add_kdebase_dep libkworkspace) )
"
DEPEND="${COMMONDEPEND}
	dev-libs/boost
	sys-devel/gettext
"
RDEPEND="${COMMONDEPEND}
	ipfilter? (
		app-arch/bzip2
		app-arch/unzip
		$(add_kdeapps_dep kdebase-kioslaves)
	)
	kross? ( $(add_kdebase_dep krosspython) )
"

PATCHES=(
	"${FILESDIR}/${P}-ipfilter.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	if ! use plasma; then
		sed -i \
			-e "s:add_subdirectory(plasma):#nada:g" \
			CMakeLists.txt || die "Failed to make plasmoid optional"
	fi

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable bwscheduler BWSCHEDULER_PLUGIN)
		$(cmake-utils_use_enable downloadorder DOWNLOADORDER_PLUGIN)
		$(cmake-utils_use_enable infowidget INFOWIDGET_PLUGIN)
		$(cmake-utils_use_with infowidget SYSTEM_GEOIP)
		$(cmake-utils_use_enable ipfilter IPFILTER_PLUGIN)
		$(cmake-utils_use_enable kross SCRIPTING_PLUGIN)
		$(cmake-utils_use_enable logviewer LOGVIEWER_PLUGIN)
		$(cmake-utils_use_enable magnetgenerator MAGNETGENERATOR_PLUGIN)
		$(cmake-utils_use_enable mediaplayer MEDIAPLAYER_PLUGIN)
		$(cmake-utils_use_enable rss SYNDICATION_PLUGIN)
		$(cmake-utils_use_enable scanfolder SCANFOLDER_PLUGIN)
		$(cmake-utils_use_enable search SEARCH_PLUGIN)
		$(cmake-utils_use_enable shutdown SHUTDOWN_PLUGIN)
		$(cmake-utils_use_enable stats STATS_PLUGIN)
		$(cmake-utils_use_enable upnp UPNP_PLUGIN)
		$(cmake-utils_use_enable webinterface WEBINTERFACE_PLUGIN)
		$(cmake-utils_use_enable zeroconf ZEROCONF_PLUGIN)
	)
	kde4-base_src_configure
}
