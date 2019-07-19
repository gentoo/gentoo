# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils qmake-utils

DESCRIPTION="Texas Hold'em poker game"
HOMEPAGE="https://www.pokerth.net/"
SRC_URI="mirror://sourceforge/pokerth/${P}.tar.gz"

LICENSE="AGPL-3 GPL-1 GPL-2 GPL-3 BitstreamVera public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

RDEPEND="dev-db/sqlite:3
	<dev-libs/boost-1.70:0=[threads(+)]
	dev-libs/libgcrypt:0
	dev-libs/protobuf:0=
	dev-libs/tinyxml[stl]
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	>=net-libs/libircclient-1.6-r2
	>=net-misc/curl-7.16
	virtual/gsasl
	!dedicated? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		media-libs/libsdl:0
		media-libs/sdl-mixer[mod,vorbis]
	)"
DEPEND="${RDEPEND}
	!dedicated? ( dev-qt/qtsql:5 )
	virtual/pkgconfig"

S="${WORKDIR}/${P}-rc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-boost-1.65-ambiguous-advance.patch
	"${FILESDIR}"/${PN}-1.1.2-protobuf.patch
)

src_prepare() {
	default
	sed -i 's/!client//' *.pro || die
}

src_configure() {
	eqmake5 pokerth.pro \
			QMAKE_CFLAGS_ISYSTEM= \
			CONFIG+="$(use dedicated || echo client)"
}

src_install() {
	dobin bin/pokerth_server chatcleaner
	dodoc docs/{gui_styling,server_setup}_howto.txt
	doman docs/pokerth.1

	if ! use dedicated; then
		dobin ${PN}
		insinto /usr/share/${PN}
		doins -r data
		domenu ${PN}.desktop
		doicon -s 128 ${PN}.png
	fi
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
