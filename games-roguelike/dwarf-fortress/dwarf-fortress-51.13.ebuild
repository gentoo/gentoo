# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop prefix xdg

MY_P="df_${PV//./_}"

DESCRIPTION="Single-player fantasy game"
HOMEPAGE="https://www.bay12games.com/dwarves/"
SRC_URI="https://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}"

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/sdl2-image[png]
	sys-apps/bubblewrap
"

BDEPEND="
	dev-util/patchelf
"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

src_compile() {
	patchelf --set-rpath "${EPREFIX}${DIR}" dwarfort *.so* || die
}

src_install() {
	insinto "${DIR}"
	exeinto "${DIR}"

	doins -r data/
	# libsdl_mixer_plugin.so seems unused. It is referenced in
	# music_and_sound.cpp but not in any binaries.
	doexe dwarfort libfmod_plugin.so libfmod.so.* libg_src_lib.so

	dobin "$(prefixify_ro "${FILESDIR}"/dwarf-fortress)"

	doicon -s 128 "${DISTDIR}"/${PN}.png
	make_desktop_entry dwarf-fortress "Dwarf Fortress"

	dodoc *.txt
}

pkg_postinst() {
	xdg_pkg_postinst

	local pv
	for pv in ${REPLACING_VERSIONS}; do
		# Check https://dwarffortresswiki.org/Release_information when bumping.
		ver_test ${pv%%.*} -lt 50.01 && ewarn "Save data from ${pv} is not compatible with this new major version."
	done
}
