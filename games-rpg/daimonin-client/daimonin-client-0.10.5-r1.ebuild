# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools

MY_P=${PN}-${PV}
DESCRIPTION="a graphical 2D tile-based MMORPG"
HOMEPAGE="http://daimonin.sourceforge.net/"
SRC_URI="http://daimonin.svn.sourceforge.net/viewvc/daimonin/main/client/?view=tar&pathrev=6021
			-> daimonin-client-0.10.5.tar.gz
		music? ( mirror://sourceforge/daimonin/Addon%20packs/Music/AllMusic.zip
			-> daimonin-client-AllMusic-20100827.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug music"

RDEPEND="
	dev-games/physfs
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	net-misc/curl"
DEPEND="${RDEPEND}
	music? ( app-arch/unzip )"

S=${WORKDIR}/client/make/linux

PATCHES=(
	"${FILESDIR}"/${P}-nozlib.patch
)

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use music ; then
		cd client/media || die
		rm -f * || die
		unpack ${PN}-AllMusic-20100827.zip
	fi
}

src_prepare() {
	default
	rm ../../src/include/z{lib,conf}.h || die
	sed -i \
		-e 's:$(d_datadir):$(DESTDIR)$(d_datadir):' \
		-e '/PROGRAMS/s:daimonin-updater::' \
		Makefile.am \
		|| die "sed failed"
	eautoreconf
	cd ../../src || die
	# Not relative to $S, so can't be applied via $PATCHES[@]
	eapply "${FILESDIR}"/${P}-datadir.patch
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
	newicon bitmaps/pentagram.png ${PN}.png
	make_desktop_entry daimonin Daimonin
}
