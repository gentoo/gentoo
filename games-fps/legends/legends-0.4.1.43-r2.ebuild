# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils unpacker

MY_P=${PN}_linux-${PV}
dir=/opt/${PN}

DESCRIPTION="Fast-paced first-person-shooter online multiplayer game, similar to Tribes"
HOMEPAGE="http://legendsthegame.net/"
SRC_URI="http://legendsthegame.net/files/${MY_P}.run
	mirror://gentoo/${PN}.png"

LICENSE="Legends LGPL-2.1+"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+dedicated"
RESTRICT="strip"

QA_TEXTRELS="${dir:1}/libSDL-1.3.so.0"
QA_FLAGS_IGNORED="${dir:1}/libSDL-1.3.so.0 ${dir:1}/LinLegends ${dir:1}/lindedicated"

DEPEND=""
RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	media-fonts/font-adobe-75dpi
	media-libs/libsdl[video,sound,opengl,abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	media-libs/libogg[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]"

S=${WORKDIR}

src_unpack() {
	unpack_makeself ${MY_P}.run
	cd "${S}"

	# keep libSDL-1.3.so because legends requires it as of 0.4.0, and
	# 1.2.6 is highest in portage
	# rm libSDL-*.so*
	rm runlegends libSDL-1.2.so.0 libopenal.so libogg.so.0 libvorbis.so.0 *.DLL || die
}

src_install() {
	insinto "${dir}"
	doins -r *

	rm "${D}/${dir}/"/{lindedicated,LinLegends,*.so.0}
	exeinto "${dir}"
	doexe lindedicated LinLegends *.so.0

	make_wrapper ${PN} "./LinLegends" "${dir}" "${dir}"
	if use dedicated ; then
		make_wrapper ${PN}-ded "./lindedicated" "${dir}" "${dir}"
	fi

	doicon "${DISTDIR}"/${PN}.png || die "doicon failed"
	make_desktop_entry legends "Legends"
}

pkg_postinst() {
	ewarn "Version ${PV} of ${PN} may give problems if there are"
	ewarn "config-files from earlier versions.  Removing the ~/.legends dir"
	ewarn "and restarting will solve this."
	echo
}
