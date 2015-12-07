# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome2-utils versionator games

MAJOR_PV=$(get_version_component_range 1-2)

DESCRIPTION="A roguelike dungeon exploration game based on the books of J.R.R. Tolkien"
HOMEPAGE="http://rephial.org/"
SRC_URI="http://rephial.org/downloads/${MAJOR_PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE="ncurses sdl +sound X"

RDEPEND="X? ( x11-libs/libX11 )
	!ncurses? ( !X? ( !sdl? ( sys-libs/ncurses:0=[unicode] ) ) )
	ncurses? ( sys-libs/ncurses:0=[unicode] )
	sdl? ( media-libs/libsdl[video,X]
		media-libs/sdl-ttf
		media-libs/sdl-image
		sound? ( media-libs/sdl-mixer[mp3]
			media-libs/libsdl[sound] ) )"
DEPEND="${RDEPEND}
	dev-python/docutils
	virtual/pkgconfig"

src_prepare() {

	sed -i -e '/libpath/s#datarootdir#datadir#' configure.ac || die
	sed -i -e "/^.SILENT/d" mk/buildsys.mk.in || die
	sed -i -e '/^DOC =/s/=.*/=/' doc/Makefile || die

	if use !sound ; then
		sed -i -e 's/sounds//' lib/Makefile || die
	fi

	# Game constant files are now system config files in Angband, but
	# users will be hidden from applying updates by default
	{
		echo "CONFIG_PROTECT_MASK=\"${GAMES_SYSCONFDIR}/${PN}/customize/\""
		echo "CONFIG_PROTECT_MASK=\"${GAMES_SYSCONFDIR}/${PN}/gamedata/\""
	} > "${T}"/99${PN} || die

	eautoreconf
}

src_configure() {
	local myconf

	if use sdl; then
		myconf="$(use_enable sound sdl-mixer)"
	else
		myconf="--disable-sdl-mixer"
	fi

	egamesconf \
		--bindir="${GAMES_BINDIR}" \
		--with-private-dirs \
		$(use_enable X x11) \
		$(use_enable sdl) \
		$(use_enable ncurses curses) \
		$(use !sdl && use !ncurses && use !X && \
			echo --enable-curses) \
		${myconf}
}

src_install() {
	DOCS="changes.txt faq.txt readme.txt thanks.txt" \
		default

	dohtml doc/manual.html
	doenvd "${T}"/99${PN}

	if use X || use sdl ; then
		if use X; then
			make_desktop_entry "angband -mx11" "Angband (X11)" "${PN}"
		fi

		if use sdl; then
			make_desktop_entry "angband -msdl" "Angband (SDL)" "${PN}"
		fi

		local s
		for s in 16 32 128 256 512
		do
			newicon -s ${s} lib/icons/att-${s}.png "${PN}.png"
		done
		newicon -s scalable lib/icons/att.svg "${PN}.svg"
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	if use X || use sdl ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	echo
	elog "Angband now uses private savefiles instead of system-wide ones."
	elog "This version of Angband is not compatible with the save files"
	elog "of previous versions."
	echo

	games_pkg_postinst
	if use X || use sdl ; then
		gnome2_icon_cache_update
	fi
}
