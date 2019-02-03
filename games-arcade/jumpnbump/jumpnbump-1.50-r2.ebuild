# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="A funny multiplayer game about cute little fluffy bunnies"
HOMEPAGE="http://www.jumpbump.mine.nu/"
SRC_URI="
	http://www.jumpbump.mine.nu/port/${P}.tar.gz
	mirror://gentoo/${P}-autotool.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X fbcon kde svga tk +music"

DEPEND="
	media-libs/sdl-mixer
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-net
	X? ( x11-libs/libXext )
	kde? ( kde-apps/kdialog )
	music? ( media-libs/sdl-mixer[mod] )
"
RDEPEND="${DEPEND}
	tk? (
		dev-lang/tcl:0=
		dev-lang/tk:0=
	)
"

src_prepare() {
	default
	eapply ../${P}-autotool.patch
	rm -f configure
	eautoreconf
	sed -i \
		-e "/PREFIX/ s:PREFIX.*:\"/usr/share/${PN}/jumpbump.dat\":" \
		globals.h \
		|| die "sed failed"
}

src_install() {
	default
	# clean up a bit.  It leaves a dep on Xdialog but ignore that.
	use fbcon || rm -f "${D}${GAMES_BINDIR}/jumpnbump.fbcon"
	use kde || rm -f "${D}${GAMES_BINDIR}/jumpnbump-kdialog"
	use svga || rm -f "${D}${GAMES_BINDIR}/jumpnbump.svgalib"
	use tk || rm -f "${D}${GAMES_BINDIR}/jnbmenu.tcl"
	newicon sdl/jumpnbump64.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Jump n Bump"
}
