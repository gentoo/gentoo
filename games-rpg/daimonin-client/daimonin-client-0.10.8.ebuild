# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A graphical 2D tile-based MMORPG"
HOMEPAGE="http://daimonin.sourceforge.net/"
SRC_URI="
	https://dev.gentoo.org/~soap/distfiles/${P}.zip
	music? ( mirror://sourceforge/daimonin/daimoninMusicLQ20100827.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug music"

RDEPEND="
	dev-games/physfs
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	net-misc/curl
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/daimonin-code-8183-trunk/client/make/linux"

src_unpack() {
	unpack ${P}.zip
	if use music; then
		rm -f daimonin-code-8183-trunk/client/media/* || die
		cd daimonin-code-8183-trunk/client || die
		unpack daimoninMusicLQ20100827.zip
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/${PN}-0.10.5-nozlib.patch
	eapply "${FILESDIR}"/${PN}-0.10.8-fix-build-system.patch

	pushd ../../src >/dev/null || die
		eapply "${FILESDIR}"/${PN}-0.10.5-datadir.patch
		eapply "${FILESDIR}"/${PN}-0.10.8-fno-common.patch
	popd >/dev/null || die

	eapply_user

	# remove bundled zlib
	rm ../../src/include/z{lib,conf}.h || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-simplelayout \
		$(use_enable debug)
}

src_install() {
	default

	cd ../.. || die
	dodoc README*

	newicon bitmaps/pentagram.png "daimonin.png"
	make_desktop_entry "daimonin" "Daimonin" "daimonin" "Game;Amusement"
}
