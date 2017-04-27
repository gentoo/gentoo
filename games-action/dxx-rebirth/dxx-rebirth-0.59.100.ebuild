# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils scons-utils toolchain-funcs xdg

MY_P="${PN}_v${PV}-src"
DESCRIPTION="Descent Rebirth - enhanced Descent 1 & 2 engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="http://www.dxx-rebirth.com/download/dxx/${MY_P}.tar.gz
	opl3-musicpack? (
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-opl3-music.dxa )
		descent2? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-opl3-music.dxa ) )
	sc55-musicpack? (
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-sc55-music.dxa )
		descent2? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa ) )
	l10n_de? (
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-briefings-ger.dxa )
		descent2? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-briefings-ger.dxa ) )
	textures? (
		descent1? ( http://www.dxx-rebirth.com/download/dxx/res/d1xr-hires.dxa ) )"

LICENSE="DXX-Rebirth GPL-3 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+data debug +descent1 +descent2 ipv6 l10n_de +music +opengl opl3-musicpack sc55-musicpack +textures"

REQUIRED_USE="|| ( descent1 descent2 )
	?? ( opl3-musicpack sc55-musicpack )
	opl3-musicpack? ( music )
	sc55-musicpack? ( music )"

DEPEND="dev-games/physfs:0=[hog,mvl,zip]
	media-libs/libsdl:0=[joystick,opengl?,sound,video]
	music? ( media-libs/sdl-mixer:0= )
	opengl? (
		virtual/opengl
		virtual/glu )"

RDEPEND="${DEPEND}
	data? (
		descent1? ( || ( games-action/descent1-data games-action/descent1-demodata ) )
		descent2? ( || ( games-action/descent2-data games-action/descent2-demodata ) ) )
	music? (
		!opl3-musicpack? ( !sc55-musicpack? ( media-libs/sdl-mixer:0=[midi] ) )
		opl3-musicpack? ( media-libs/sdl-mixer:0=[vorbis] )
		sc55-musicpack? ( media-libs/sdl-mixer:0=[vorbis] ) )
	!games-action/d1x-rebirth
	!games-action/d2x-rebirth"

S="${WORKDIR}/${MY_P}"

# Remove hardcoded optimisation flags.
# Change share path to use old d1x/d2x locations.
PATCHES=( "${FILESDIR}"/${P}-{flags,sharepath}.patch )

src_compile() {
	tc-export CXX
	escons \
		prefix="${EPREFIX}"/usr \
		d1x=$(usex descent1 1 0) \
		d2x=$(usex descent2 1 0) \
		debug=$(usex debug 1 0) \
		ipv6=$(usex ipv6 1 0) \
		opengl=$(usex opengl 1 0) \
		sdlmixer=$(usex music 1 0) \
		verbosebuild=1
}

src_install() {
	local DV PROGRAM

	for DV in 1 2; do
		use descent${DV} || continue
		PROGRAM=d${DV}x-rebirth

		docinto ${PROGRAM}
		edos2unix ${PROGRAM}/*.txt
		dodoc ${PROGRAM}/*.txt

		insinto /usr/share/games/d${DV}x
		use opl3-musicpack && doins "${DISTDIR}"/d${DV}xr-opl3-music.dxa
		use sc55-musicpack && doins "${DISTDIR}"/d${DV}xr-sc55-music.dxa
		use l10n_de && doins "${DISTDIR}"/d${DV}xr-briefings-ger.dxa

		dobin ${PROGRAM}/${PROGRAM}
		make_desktop_entry ${PROGRAM} "Descent ${DV} Rebirth" ${PROGRAM}
		doicon ${PROGRAM}/${PROGRAM}.xpm
	done

	if use textures && use descent1; then
		insinto /usr/share/games/d1x
		doins "${DISTDIR}"/d1xr-hires.dxa
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use data; then
		elog "To play the game enable USE=\"data\" or manually "
		elog "copy the files to ${EPREFIX}/usr/share/games/{d1x,d2x}."
		elog "See each game's INSTALL.txt for details."
		echo
	fi
}
