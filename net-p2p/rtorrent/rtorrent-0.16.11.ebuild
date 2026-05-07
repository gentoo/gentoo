# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# require 64-bit integer
LUA_COMPAT=( lua5-{3,4} )

inherit autotools lua-single systemd toolchain-funcs

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rtorrent.net"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
else
	SRC_URI="https://github.com/rakshasa/rtorrent/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug lua selinux systemd test tinyxml2 xmlrpc"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	tinyxml2? ( !xmlrpc )
"

COMMON_DEPEND="
	~net-libs/libtorrent-${PV}
	sys-libs/ncurses:0=
	virtual/zlib:=
	lua? ( ${LUA_DEPS} )
	systemd? ( sys-apps/systemd:= )
	xmlrpc? ( dev-libs/xmlrpc-c:=[libxml2] )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/nlohmann_json
	test? ( dev-util/cppunit )
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-rtorrent )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.16.9-cross_checks.patch
)

DOCS=( doc/rtorrent.rc )

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	# use system-json
	rm -r src/rpc/nlohmann || die
	sed -e 's@"rpc/nlohmann/json.h"@<nlohmann/json.hpp>@' \
		-i src/rpc/jsonrpc.cc || die

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	if [[ ${CHOST} != *-darwin* ]]; then
		# syslibroot is only for macos, change to sysroot for others
		sed -i 's/Wl,-syslibroot,/Wl,--sysroot,/' "${S}/scripts/common.m4" || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with lua)
		$(use_with systemd)
		$(usev xmlrpc --with-xmlrpc-c=$(tc-getPKG_CONFIG))
		$(usev tinyxml2 --with-xmlrpc-tinyxml2)
	)

	use lua && myeconfargs+=(
		LUA_INCLUDE="$(lua_get_CFLAGS)"
		LUA_LIB="$(lua_get_LIBS)"
		LUA_VERSION="${ELUA/lua/}"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doman doc/rtorrent.1

	# lua file is installed then in the proper directory
	rm "${ED}"/usr/share/rtorrent/lua/rtorrent.lua || die
	if use lua; then
		insinto $(lua_get_lmod_dir)
		doins lua/${PN}.lua
	fi

	newinitd "${FILESDIR}/rtorrent-r1.init" rtorrent
	newconfd "${FILESDIR}/rtorrentd.conf" rtorrent
	systemd_newunit "${FILESDIR}/rtorrentd_at-r1.service" "rtorrentd@.service"
}

pkg_postinst() {
	einfo "This release could introduce new commands to configure RTorrent."
	einfo "Please read the release notes before restarting:"
	einfo "https://github.com/rakshasa/rtorrent/releases"
	einfo ""
	einfo "For configuration assistance, see:"
	einfo "https://github.com/rakshasa/rtorrent/wiki"
}
