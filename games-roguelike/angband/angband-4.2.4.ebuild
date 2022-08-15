# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg-utils

DESCRIPTION="A roguelike dungeon exploration game based on the books of J.R.R. Tolkien"
HOMEPAGE="https://rephial.org/"
SRC_URI="https://github.com/angband/angband/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~steils/distfiles/${P}-man.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="+ncurses sdl sound +X"

REQUIRED_USE="sound? ( sdl )
	|| ( X ncurses )"

RDEPEND="X? (
		media-fonts/font-misc-misc
		x11-libs/libX11
	)
	ncurses? ( sys-libs/ncurses:=[unicode(+)] )
	sdl? (
		media-libs/libsdl2[video,X]
		media-libs/sdl2-image[png]
		media-libs/sdl2-ttf
		sound? (
			media-libs/libsdl2[sound]
			media-libs/sdl2-mixer[mp3]
		)
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i -e '/libpath/s#datarootdir#datadir#' configure.ac || die
	sed -i -e "/^.SILENT/d" mk/buildsys.mk.in || die

	if use !sound ; then
		sed -i -e 's/sounds//' lib/Makefile || die
	fi

	# Game constant files are now system config files in Angband, but
	# users will be hidden from applying updates by default
	{
		echo "CONFIG_PROTECT_MASK=\"/etc/${PN}/customize/\""
		echo "CONFIG_PROTECT_MASK=\"/etc/${PN}/gamedata/\""
	} > "${T}"/99${PN} || die

	eautoreconf
}

src_configure() {
	local myconf=(
		--bindir="${EPREFIX}"/usr/bin
		--with-private-dirs
		$(use_enable X x11)
		$(use_enable ncurses curses)
	)
	if use sdl; then
		myconf+=(
			--enable-sdl2
			$(use_enable sound sdl2-mixer)
		)
	fi

	econf "${myconf[@]}"
}

src_install() {
	default

	dodoc changes.txt README.md
	doman "${WORKDIR}"/${PN}.1
	doenvd "${T}"/99${PN}

	if use X || use sdl; then
		use X && make_desktop_entry "angband -mx11" "Angband (X11)" "${PN}"
		use sdl && make_desktop_entry "angband -msdl2" "Angband (SDL2)" "${PN}"

		local s
		for s in 16 32 128 256 512; do
			newicon -s ${s} lib/icons/att-${s}.png "${PN}.png"
		done
		newicon -s scalable lib/icons/att.svg "${PN}.svg"
	fi
}

pkg_postinst() {
	if use X || use sdl; then
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use X || use sdl; then
		xdg_icon_cache_update
	fi
}
