# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils games

DESCRIPTION="Faster Than Light: A spaceship simulation real-time roguelike-like game"
HOMEPAGE="http://www.ftlgame.com/"
SRC_URI="FTL.${PV}.tar.gz"

LICENSE="all-rights-reserved Boost-1.0 free-noncomm MIT bundled-libs? ( FTL LGPL-2.1 ZLIB libpng )"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="fetch bindist splitdebug"

RDEPEND="
	sys-devel/gcc[cxx]
	virtual/opengl
	!bundled-libs? (
		media-libs/devil[png]
		media-libs/freetype:2
		media-libs/libsdl[X,sound,joystick,opengl,video]
		sys-libs/zlib
	)"

QA_PREBUILT="${GAMES_PREFIX_OPT#/}/${PN}/bin/${PN}
	${GAMES_PREFIX_OPT#/}/${PN}/lib/*"

S=${WORKDIR}/${PN}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_prepare() {
	if ! use bundled-libs ; then
		# no system lib for libbass available
		find data/${ARCH}/lib -type f \! -name "libbass*" -delete || die
	fi
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r data/resources

	exeinto "${dir}"/bin
	doexe data/${ARCH}/bin/${PN}
	exeinto "${dir}"/lib
	doexe data/${ARCH}/lib/*.so*

	games_make_wrapper ${PN} "${dir}/bin/${PN}" "${dir}" "${dir}/lib"
	make_desktop_entry ${PN} "Faster Than Light" "/usr/share/pixmaps/FTL.bmp"

	newicon data/resources/exe_icon.bmp FTL.bmp
	dohtml ${PN}_README.html

	prepgamesdirs
}
