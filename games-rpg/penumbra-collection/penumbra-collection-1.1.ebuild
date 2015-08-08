# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker gnome2-utils games

MY_PN="PenumbraCollection"

DESCRIPTION="Scary first-person adventure game trilogy which focuses on story, immersion and puzzles"
HOMEPAGE="http://www.penumbragame.com/"
SRC_URI="${MY_PN}-${PV}.sh"

LICENSE="PENUMBRA-COLLECTION"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="
	x11-libs/fltk:1
	media-gfx/nvidia-cg-toolkit[abi_x86_32(-)]
	>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
	>=media-libs/freealut-1.1.0-r3[abi_x86_32(-)]
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	>=media-libs/libogg-1.3.1[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[X,sound,video,opengl,abi_x86_32(-)]
	>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
	>=media-libs/sdl-image-1.2.12-r1[gif,jpeg,png,abi_x86_32(-)]
	>=media-libs/sdl-ttf-2.0.11-r1[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXft[abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]"
DEPEND="app-arch/xz-utils"

gamedir=${GAMES_PREFIX_OPT}/${MY_PN}
INSTALL_KEY_FILE=${gamedir}/collectionkey

QA_PREBUILT="${gamedir}/Overture/penumbra.bin
	${gamedir}/BlackPlague/requiem.bin
	${gamedir}/BlackPlague/blackplague.bin"

if [[ $ARCH == amd64 ]] ; then
	QA_PREBUILT="${QA_PREBUILT}
		${gamedir}/BlackPlague/lib/libfltk.so.1.1
		${gamedir}/BlackPlague/lib/libCgGL.so
		${gamedir}/BlackPlague/lib/libCg.so
		${gamedir}/Overture/lib/libfltk.so.1.1
		${gamedir}/Overture/lib/libCgGL.so
		${gamedir}/Overture/lib/libCg.so"
fi

S=${WORKDIR}/${MY_PN}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_unpack() {
	unpack_makeself

	mv subarch subarch.tar.lzma || die
	unpack ./subarch.tar.lzma

	mv instarchive_all instarchive_all.tar.lzma || die
	unpack ./instarchive_all.tar.lzma
}

src_install() {
	local destDir episodeDir library directory
	# perform instalation for each episode; note that Requiem is extension of
	# Black Plague so it has no dedicated directory at this level
	for episodeDir in Overture BlackPlague; do
		destDir="${gamedir}/${episodeDir}"

		insinto "${destDir}"

		# install every directory recursively except lib
		for directory in \
			$(find ${episodeDir}/* -maxdepth 0 -type d ! -name lib); do
			doins -r "${directory}"
		done

		# amd64 does not provide some libs, use bundled ones
		if use amd64 ; then
			exeinto "${gamedir}/${episodeDir}/lib"
			for library in \
				libfltk.so.1.1 \
				libCgGL.so \
				libCg.so; do
				doexe ${episodeDir}/lib/${library}
			done
		fi

		doins ${episodeDir}/*.cfg

		exeinto "${destDir}"
		doexe ${episodeDir}/openurl.sh ${episodeDir}/*.bin

		# make sure that cache files are newer than models otherwise the game
		# tries to regenerate them which sometimes causes a crash (as reported
		# in bug #278326 comment #6)
		touch "${D}/${destDir}"/core/*cache/*
	done

	newicon -s 64 Overture/penumbra.png penumbra-overture.png
	newicon -s 64 BlackPlague/penumbra.png penumbra-blackplague.png
	newicon -s 64 BlackPlague/requiem.png penumbra-requiem.png

	games_make_wrapper penumbra-overture ./penumbra.bin \
		"${gamedir}/Overture" "${gamedir}/Overture/lib"
	games_make_wrapper penumbra-blackplague ./blackplague.bin \
		"${gamedir}/BlackPlague" "${gamedir}/BlackPlague/lib"
	games_make_wrapper penumbra-requiem ./requiem.bin \
		"${gamedir}/BlackPlague" "${gamedir}/BlackPlague/lib"

	make_desktop_entry penumbra-overture "Penumbra: Overture" \
		penumbra-overture
	make_desktop_entry penumbra-blackplague "Penumbra: Black Plague" \
		penumbra-blackplague
	make_desktop_entry penumbra-requiem "Penumbra: Requiem" \
		penumbra-requiem

	docinto Overture
	dodoc Overture/CHANGELOG.txt Overture/Manual.pdf Overture/README.linux
	docinto BlackPlague
	dodoc BlackPlague/Manual.pdf BlackPlague/README.linux

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	if [[ -f "${INSTALL_KEY_FILE}" ]] ; then
		einfo "The installation key file already exists: ${INSTALL_KEY_FILE}"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "  emerge --config ${PN}"
		ewarn "To enter your installation key."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
	einfo "If you uninstalled ${PN} you might want to remove the keyfile as well in"
	einfo "  ${INSTALL_KEY_FILE}"
}

pkg_config() {
	local key1 key2

	ewarn "Your installation key is NOT checked for validity here."
	ewarn "Make sure you type it in correctly."
	ewarn "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "The key format is: XXXX-XXXX-XXXX-XXXX"
	while true ; do
		einfo "Please enter your key:"
		read key1
		if [[ -z "${key1}" ]] ; then
			echo "You entered a blank key. Try again."
			continue
		fi
		einfo "Please re-enter your key:"
		read key2
		if [[ -z "${key2}" ]] ; then
			echo "You entered a blank key. Try again."
			continue
		fi

		if [[ "${key1}" == "${key2}" ]] ; then
			echo "${key1}" | tr '[:lower:]' '[:upper:]' > "${INSTALL_KEY_FILE}"
			echo -e "// Do not give this file to ANYONE.\n// Frictional Games Support will NEVER ask for this file" \
				>> "${INSTALL_KEY_FILE}"
			einfo "Created ${INSTALL_KEY_FILE}"
			break
		else
			eerror "Your installation key entries do not match. Try again."
		fi
	done
}
