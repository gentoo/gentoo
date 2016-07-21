# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib gnome2-utils qmake-utils

MY_PN="RetroShare"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="P2P private sharing application"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/retroshare_0.5.5-0.7068.tar.gz"

# pegmarkdown can also be used with MIT
LICENSE="GPL-2 GPL-3 Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cli feedreader links-cloud qt4 voip"
REQUIRED_USE="|| ( cli qt4 )
	feedreader? ( qt4 )
	links-cloud? ( qt4 )
	voip? ( qt4 )"

RDEPEND="
	app-arch/bzip2
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
	qt4? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	voip? (
		media-libs/speex
		dev-qt/qt-mobility[multimedia]
		dev-qt/qtmultimedia:4
	)"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-qt/qtcore:4
	virtual/pkgconfig"

S="${WORKDIR}/retroshare-0.5.5/src"

src_prepare() {
	local dir

	sed -i \
		-e "s|/usr/lib/retroshare/extensions/|/usr/$(get_libdir)/${PN}/extensions/|" \
		libretroshare/src/rsserver/rsinit.cc \
		|| die "sed failed"

	rs_src_dirs="libbitdht/src openpgpsdk/src libretroshare/src supportlibs/pegmarkdown"
	use cli && rs_src_dirs="${rs_src_dirs} retroshare-nogui/src"
	use qt4 && rs_src_dirs="${rs_src_dirs} retroshare-gui/src"
	use links-cloud && rs_src_dirs="${rs_src_dirs} plugins/LinksCloud"
	use feedreader && rs_src_dirs="${rs_src_dirs} plugins/FeedReader"

	if use voip ; then
		rs_src_dirs="${rs_src_dirs} plugins/VOIP"
		echo "QT += multimedia" >> "plugins/VOIP/VOIP.pro" || die
		echo "CONFIG += mobility" >> "plugins/VOIP/VOIP.pro" || die
	fi
}

src_configure() {
	for dir in ${rs_src_dirs} ; do
		cd "${S}"/${dir} || die
		eqmake4
	done
}

src_compile() {
	local dir

	for dir in ${rs_src_dirs} ; do
		emake -C ${dir}
	done

	unset rs_src_dirs
}

src_install() {
	local i
	local extension_dir="/usr/$(get_libdir)/${PN}/extensions/"

	use cli && dobin retroshare-nogui/src/retroshare-nogui
	use qt4 && dobin retroshare-gui/src/RetroShare

	exeinto "${extension_dir}"
	use feedreader && doexe plugins/FeedReader/*.so*
	use links-cloud && doexe plugins/LinksCloud/*.so*
	use voip && doexe plugins/VOIP/*.so*

	insinto /usr/share/RetroShare
	doins libbitdht/src/bitdht/bdboot.txt

	dodoc README.txt
	make_desktop_entry RetroShare
	for i in 24 48 64 ; do
		doicon -s ${i} build_scripts/Ubuntu_src/data/${i}x${i}/${PN}.png
	done
	doicon -s 128 build_scripts/Ubuntu_src/data/${PN}.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
