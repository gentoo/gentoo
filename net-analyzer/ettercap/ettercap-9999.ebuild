# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc gtk ipv6 libressl ncurses +plugins test"
RESTRICT="!test? ( test )"

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
	ncurses? ( >=sys-libs/ncurses-5.3:= )
	plugins? ( >=net-misc/curl-7.26.0 )"
DEPEND="${RDEPEND}
	doc? ( app-text/ghostscript-gpl
		sys-apps/groff )
	test? ( dev-libs/check )
	sys-devel/flex
	virtual/yacc"

src_prepare() {
	sed -i "s:Release:Release Gentoo:" CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CURSES="$(usex ncurses)"
		-DENABLE_GTK="$(usex gtk)"
		-DENABLE_PLUGINS="$(usex plugins)"
		-DENABLE_IPV6="$(usex ipv6)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_PDF_DOCS="$(usex doc)"
		-DBUNDLED_LIBS=OFF
		-DSYSTEM_LIBS=ON
		-DINSTALL_SYSCONFDIR="${EROOT}"etc
	)
		#right now we only support gtk2, but ettercap also supports gtk3
		#do we care? do we want to support both?
	cmake-utils_src_configure
}
