# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator games

MAJOR_PV=$(get_version_component_range 1-2)
MY_P=${PN}-v${PV}

DESCRIPTION="A roguelike dungeon exploration game based on the books of J.R.R. Tolkien"
HOMEPAGE="http://rephial.org/"
SRC_URI="http://rephial.org/downloads/${MAJOR_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="ncurses sdl +sound X"

RDEPEND="X? ( x11-libs/libX11 )
	!ncurses? ( !X? ( !sdl? ( sys-libs/ncurses ) ) )
	ncurses? ( sys-libs/ncurses )
	sdl? ( media-libs/libsdl[video,X]
		media-libs/sdl-ttf
		media-libs/sdl-image
		sound? ( media-libs/sdl-mixer
			media-libs/libsdl[sound] ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( changes.txt faq.txt readme.txt thanks.txt )

src_prepare() {
	# fix paths
	sed -i \
		-e '/libpath/s#datarootdir#datadir#' \
		-e '/X_PRE_LIBS/s:-lSM -lICE::' \
		configure || die

	sed -i \
		-e "/^.SILENT/d" \
		mk/buildsys.mk.in || die
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
	default

	# Edit files are now system config files in Angband, but
	# users will be hidden from applying updates by default
	echo "CONFIG_PROTECT_MASK=\"${GAMES_SYSCONFDIR}/${PN}/edit/\"" \
		> "${T}"/99${PN}
	doenvd "${T}"/99${PN} || die

	# Create desktop entries if required.
	ICON_LOC="${GAMES_DATADIR}/${PN}/xtra/icon/att-32.png"
	if use X; then
		make_desktop_entry "angband -mx11" "Angband (X11)" "${ICON_LOC}"
	fi

	if use sdl; then
		make_desktop_entry "angband -msdl" "Angband (SDL)" "${ICON_LOC}"
	fi

	use ncurses || rm -rf "${D}${GAMES_DATADIR}/${PN}/xtra/graf"
	use sound || rm -rf "${D}${GAMES_DATADIR}/${PN}/xtra/sound"

	prepgamesdirs
}

pkg_postinst() {
	echo
	elog "Angband now uses private savefiles instead of system-wide ones"
	elog "This version of Angband is not compatible with the save files"
	elog "of previous versions"
	echo

	games_pkg_postinst
}
