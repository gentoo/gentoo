# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# require 64-bit integer
LUA_COMPAT=( lua5-{3,4} )

inherit autotools linux-info lua-single systemd toolchain-funcs

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
else
	SRC_URI="https://github.com/rakshasa/rtorrent/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~ppc ppc64 x86 ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug lua selinux test tinyxml2 xmlrpc"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	tinyxml2? ( !xmlrpc )
"

COMMON_DEPEND="
	~net-libs/libtorrent-${PV}
	net-misc/curl
	sys-libs/ncurses:0=
	lua? ( ${LUA_DEPS} )
	xmlrpc? ( dev-libs/xmlrpc-c:=[libxml2] )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/nlohmann_json
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-rtorrent )
"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

DOCS=( doc/rtorrent.rc )

PATCHES=(
	# fix configure w/ slibtool. merged in 0.16.0
	"${FILESDIR}"/${PN}-0.15.5-find_grep.patch
)

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
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
	# used by xmlrpc-c-config
	tc-export PKG_CONFIG
	local myeconfargs=(
		$(use_enable debug)
		$(use_with lua)
		$(usev xmlrpc --with-xmlrpc-c)
		$(usev tinyxml2 --with-xmlrpc-tinyxml2)
	)

	use lua && myeconfargs+=(
		LUA_INCLUDE="-I$(lua_get_include_dir)"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doman doc/rtorrent.1

	if use lua; then
		insinto $(lua_get_lmod_dir)
		doins ${PN}.lua
	fi

	newinitd "${FILESDIR}/rtorrent-r1.init" rtorrent
	newconfd "${FILESDIR}/rtorrentd.conf" rtorrent
	systemd_newunit "${FILESDIR}/rtorrentd_at-r1.service" "rtorrentd@.service"
}
