# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION=2.8

inherit cmake-utils

DESCRIPTION="A suite for man in the middle attacks"
HOMEPAGE="https://github.com/Ettercap/ettercap"

LICENSE="GPL-2+"
SLOT="0"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Ettercap/${PN}.git"
else
	SRC_URI="https://github.com/Ettercap/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz" #mirror does not work
	KEYWORDS="~alpha ~amd64 ~arm ~sparc ~x86 ~x86-fbsd"
fi
#IUSE="doc gtk ipv6 ncurses +plugins test"
IUSE="doc gtk ipv6 libressl ncurses +plugins"

RDEPEND="dev-libs/libbsd
	dev-libs/libpcre
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/libnet:1.1
	>=net-libs/libpcap-0.8.1
	sys-libs/zlib
	gtk? (
		>=dev-libs/atk-1.2.4
		>=dev-libs/glib-2.2.2:2
		media-libs/freetype
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.2.2:2
		>=x11-libs/pango-1.2.3
	)
	ncurses? ( sys-libs/ncurses:0= )
	plugins? ( >=net-misc/curl-7.26.0 )"
DEPEND="${RDEPEND}
	doc? ( app-text/ghostscript-gpl
		sys-apps/groff )
	sys-devel/flex
	virtual/yacc"

src_prepare() {
	sed -i "s:Release:Release Gentoo:" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable ncurses CURSES)
		$(cmake-utils_use_enable gtk)
		$(cmake-utils_use_enable plugins)
		$(cmake-utils_use_enable ipv6)
		$(cmake-utils_use_enable doc PDF_DOCS)
		-DBUNDLED_LIBS=OFF
		-DSYSTEM_LIBS=ON
		-DINSTALL_SYSCONFDIR="${EROOT}"etc
	)
		#right now we only support gtk2, but ettercap also supports gtk3
		#do we care? do we want to support both?

		#we want to enable testing but it fails right now
		#we want to disable the bundled crap, but we are missing at least "libcheck"
		#if we want to enable tests, we need to fix it, and either package libcheck or allow bundled version
		#$(cmake-utils_use_enable test TESTS)
	cmake-utils_src_configure
}
