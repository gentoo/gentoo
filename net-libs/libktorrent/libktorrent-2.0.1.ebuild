# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} != 9999* ]]; then
	inherit versionator
	# upstream likes to skip that _ in beta releases
	MY_PV="${PV/_/}"
	KTORRENT_VERSION=$(($(get_major_version)+3)).$(get_version_component_range 2 ${MY_PV})
	MY_P="${PN}-${MY_PV}"

	SRC_URI="mirror://kde/stable/ktorrent/${KTORRENT_VERSION}/${MY_P}.tar.xz"
	S="${WORKDIR}"/"${MY_P}"

	KEYWORDS="~amd64 ~arm ~x86"
else
	KEYWORDS=""
fi

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="BitTorrent library based on KDE Frameworks"
HOMEPAGE="http://ktorrent.pwsp.net/"

LICENSE="GPL-2+"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5]
	>=dev-libs/gmp-6.0.0a:0=
	dev-libs/libgcrypt:0=
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	!net-libs/libktorrent:4
"

src_prepare() {
	kde5_src_prepare

	# Gentoo workaround because gmp.h in MULTILIB_WRAPPED_HEADERS is breaking this
	sed -i -e "/^find_package/ s/\"\${LibGMP_MIN_VERSION}\" //" \
		CMakeLists.txt || die
	sed -i -e "/^find_dependency/ s/ \"@LibGMP_MIN_VERSION@\"//" \
		LibKTorrentConfig.cmake.in || die

	# do not build non-installed example binary
	sed -i -e "/add_subdirectory(examples)/d" CMakeLists.txt || die

	if ! use test ; then
		sed -i -e "/add_subdirectory(testlib)/d" CMakeLists.txt || die
		sed -i -e "/add_subdirectory(tests)/d" \
			src/{datachecker,dht,diskio,download,magnet,mse,net,peer,util,utp,torrent}/CMakeLists.txt \
			|| die "Failed to remove tests"
	fi
}
