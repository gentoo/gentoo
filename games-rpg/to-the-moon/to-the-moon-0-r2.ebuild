# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

MY_PN="ToTheMoon"

DESCRIPTION="Two doctors traversing the memories of a dying man to fulfill his last wish"
HOMEPAGE="https://freebirdgames.com/games/to-the-moon/"
SRC_URI="${MY_PN}_linux_1389114090.sh"
S="${WORKDIR}/data"

LICENSE="all-rights-reserved bundled-libs? ( LGPL-2 LGPL-2.1 ZLIB )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch"

QA_PREBUILT="
	opt/${PN}/${MY_PN}.bin*
	opt/${PN}/lib/*
	opt/${PN}/lib64/*"

# TODO: unbundling sdl-sound breaks the game
RDEPEND="
	media-libs/libglvnd[X]
	sys-libs/libxcrypt:0/1
	sys-libs/zlib
	!bundled-libs? (
		dev-libs/libsigc++:2
		>=media-libs/libsdl2-2.0.1[X,joystick,opengl,sound,threads(+),video]
		media-libs/openal
		media-libs/sdl2-image[png]
		media-libs/sdl2-ttf
	)
"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to your DISTDIR directory."
}

src_unpack() {
	# mojo stuff inside makeself archive, unpack_makeself fails
	local lastline=$(( $(grep -a -h -n -m 1 -F -e "Extra newline, because in very rare cases (OpenSolaris) stub is directly added after script" "${DISTDIR}/${A}" | cut -d':' -f1) + 1 ))
	[[ ${lastline} ]] || die "no last line"

	local offset=$(head -n ${lastline} "${DISTDIR}/${A}" | wc -c)
	[[ ${offset} ]] || die "no offset"

	dd ibs=${offset} skip=1 if="${DISTDIR}/${A}" of="${T}"/moon.zip || die
	unpack_zip "${T}"/moon.zip
}

src_install() {
	local dir=/opt/${PN}
	local libsuffix=$(usex amd64 64 '')
	local arch=$(usex amd64 x86_64 x86)

	insinto ${dir}
	doins -r noarch/{Audio,Data,Fonts,Graphics,Game.ini,mkxp.conf,ToTheMoon.png}

	exeinto ${dir}
	doexe ${arch}/${MY_PN}.bin.${arch}

	exeinto ${dir}/lib${libsuffix}
	if use bundled-libs ; then
		doexe ${arch}/lib${libsuffix}/*
	else
		doexe ${arch}/lib${libsuffix}/libSDL_sound-1.0.so.1
	fi

	make_wrapper ${PN} ./${MY_PN}.bin.${arch} ${dir}{,/lib${libsuffix}}

	newicon noarch/${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} "To the Moon"
}
