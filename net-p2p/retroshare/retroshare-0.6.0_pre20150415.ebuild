# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/retroshare/retroshare-0.6.0_pre20150415.ebuild,v 1.2 2015/06/14 23:14:34 pinkbyte Exp $

EAPI=5

inherit eutils gnome2-utils multilib qmake-utils

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.bz2"

# pegmarkdown can also be used with MIT
LICENSE="GPL-2 GPL-3 Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="cli feedreader qt5 voip"
REQUIRED_USE="|| ( cli qt5 )
	feedreader? ( qt5 )
	voip? ( qt5 )"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlcipher
	dev-libs/openssl:0
	gnome-base/libgnome-keyring
	net-libs/libupnp
	sys-libs/zlib
	cli? (
		dev-libs/protobuf
		net-libs/libssh[server]
	)
	feedreader? (
		dev-libs/libxml2
		dev-libs/libxslt
		net-misc/curl
	)
	qt5? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
	)
	voip? (
		media-libs/speex
	)"
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	virtual/pkgconfig"

src_prepare() {
	local dir

	sed -i \
		-e "s|/usr/lib/retroshare/extensions/|/usr/$(get_libdir)/${PN}/extensions/|" \
		libretroshare/src/rsserver/rsinit.cc \
		|| die "sed failed"

	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src supportlibs/pegmarkdown"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use qt5 && rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
	use feedreader && rs_src_dirs="${rs_src_dirs} plugins/FeedReader"

	use voip && rs_src_dirs="${rs_src_dirs} plugins/VOIP"

	epatch "${FILESDIR}/${PN}-0.6.0-force-sqlcipher.patch"

	epatch_user
}

src_configure() {
	for dir in ${rs_src_dirs} ; do
		pushd "${S}/${dir}" 2>/dev/null || die
		eqmake5
		popd 2>/dev/null || die
	done
}

src_compile() {
	local dir

	for dir in ${rs_src_dirs} ; do
		emake -C "${dir}"
	done

	unset rs_src_dirs
}

src_install() {
	local i
	local extension_dir="/usr/$(get_libdir)/${PN}/extensions/"

	use cli && dobin retroshare-nogui/src/retroshare-nogui
	use qt5 && dobin retroshare-gui/src/RetroShare

	exeinto "${extension_dir}"
	use feedreader && doexe plugins/FeedReader/*.so*
	use voip && doexe plugins/VOIP/*.so*

	insinto /usr/share/RetroShare06
	doins libbitdht/src/bitdht/bdboot.txt

	dodoc README.txt
	make_desktop_entry RetroShare
	for i in 24 48 64 ; do
		doicon -s ${i} "build_scripts/Debian+Ubuntu/data/${i}x${i}/${PN}.png"
	done
	doicon -s 128 "build_scripts/Debian+Ubuntu/data/${PN}.png"
}

pkg_preinst() {
	if [[ "${REPLACING_VERSIONS}" = "0.5*"  ]]; then
		elog "You are upgrading from Retroshare 0.5.* to ${PV}"
		elog "Version 0.6.* is backward-incompatible with 0.5 branch"
		elog "and clients with 0.6.* can not connect to clients that have 0.5.*"
		elog "It's recommended to drop all your configuration and either"
		elog "generate a new certificate or import existing from a backup"
	fi
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
