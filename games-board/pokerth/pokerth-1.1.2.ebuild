# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="Texas Hold'em poker game"
HOMEPAGE="https://www.pokerth.net/"
SRC_URI="mirror://sourceforge/pokerth/${P}.tar.gz"

LICENSE="AGPL-3 GPL-1 GPL-2 GPL-3 BitstreamVera public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

RDEPEND="dev-db/sqlite:3
	dev-libs/boost:0=[threads(+)]
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
	dev-cpp/websocketpp
	!dedicated? ( dev-qt/qtsql:5 )"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}-rc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-boost-1.65-ambiguous-advance.patch
	"${FILESDIR}"/${PN}-1.1.2-protobuf.patch
	"${FILESDIR}"/${PN}-1.1.2-boost-1.66.patch
	"${FILESDIR}"/${PN}-1.1.2-fix-includes.patch
	# unbundle dev-cpp/websocketpp
	"${FILESDIR}"/${PN}-1.1.2-system-websockets.patch
)

src_prepare() {
	xdg_src_prepare
	sed -i 's/!client//' *.pro || die

	# delete bundled dev-cpp/websocketpp to be safe
	rm -r src/third_party/websocketpp || die
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
