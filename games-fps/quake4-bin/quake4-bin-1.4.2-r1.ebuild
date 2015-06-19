# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake4-bin/quake4-bin-1.4.2-r1.ebuild,v 1.3 2015/06/14 17:01:51 ulm Exp $

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Sequel to Quake 2, an id Software 3D first-person shooter"
HOMEPAGE="http://www.quake4game.com/"
SRC_URI="mirror://idsoftware/quake4/linux/quake4-linux-${PV}.x86.run"

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="cdinstall dedicated linguas_cs linguas_fr linguas_it linguas_pl linguas_ru"
RESTRICT="strip"

# QUAKE4 NEEDS s3tc support, which can be obtained for OSS drivers via
# media-libs/libtxc_dxtn and is built into the proprietary drivers.
# depend optionally on them but elog too, in case a user has both
# proprietary and OSS drivers installed and sees the segfault.

RDEPEND="sys-libs/glibc
	amd64? ( sys-libs/glibc[multilib] )
	sys-libs/zlib[abi_x86_32(-)]
	dedicated? ( app-misc/screen )
	!dedicated? (
		|| (
			>=media-libs/libtxc_dxtn-1.0.1-r1[abi_x86_32(-)]
			x11-drivers/nvidia-drivers
			>=x11-drivers/ati-drivers-8.8.25-r1
		)
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=media-libs/libsdl-1.2.15-r4[X,opengl,sound,abi_x86_32(-)]
	)
	cdinstall? ( games-fps/quake4-data )"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/quake4
Ddir=${D}/${dir}

QA_TEXTRELS="${dir:1}/pb/pbag.so
	${dir:1}/pb/pbags.so
	${dir:1}/pb/pbcl.so
	${dir:1}/pb/pbcls.so
	${dir:1}/pb/pbsv.so
	${dir:1}/libSDL-1.2.id.so.0"
QA_EXECSTACK="${dir:1}/quake4.x86
	${dir:1}/quake4smp.x86
	${dir:1}/q4ded.x86
	${dir:1}/libSDL-1.2.id.so.0"

zpaklang() {
	if ! use linguas_${1} ; then
		einfo "Removing ${2} zpak files"
		rm -f q4base/zpak_${2}*
	fi
}

src_unpack() {
	unpack_makeself ${A}

	mv q4icon.bmp quake4.bmp || die

	# Am including the Spanish files because Spanish is the default language
	#zpaklang es spanish
	zpaklang cs czech
	zpaklang fr french
	zpaklang it italian
	zpaklang pl polish
	zpaklang ru russian

	# Rename the .off files, so they will be used
	cd q4base
	if [[ ! -z $(ls *.off 2> /dev/null) ]] ; then
		local f
		for f in *.off ; do
			einfo "Renaming ${f}"
			mv "${f}" "${f%.off}" || die "mv ${f}"
		done
	fi
}

src_install() {
	insinto "${dir}"
	doins CHANGES* License.txt sdl.patch.1.2.10 us/version.info
	doins -r pb q4mp
	dodoc README*

	insinto "${dir}"/q4base
	doins q4base/* us/q4base/* || die "doins q4base"
	games_make_wrapper quake4-ded ./q4ded.x86 "${dir}" "${dir}"

	exeinto "${dir}"
	doexe openurl.sh bin/Linux/x86/q4ded.x86

	if ! use dedicated ; then
		doexe bin/Linux/x86/{quake4{,smp}.x86,*.id.so.?}
		doicon quake4.bmp || die "doicon"
		games_make_wrapper quake4 "./quake4.x86" "${dir}" "${dir}"
		games_make_wrapper quake4-smp ./quake4smp.x86 "${dir}" "${dir}"
		icon_path="quake4"
		if [ -e "${FILESDIR}"/quake4.png ]
		then
			doicon "${FILESDIR}"/quake4.png || die "copying icon"
		elif [ -e "${DISTDIR}"/quake4.png ]
		then
			doicon "${DISTDIR}"/quake4.png || die "copying icon"
		else
			icon_path=/usr/share/pixmaps/quake4.bmp
		fi
		make_desktop_entry quake4 "Quake IV" ${icon_path}
		make_desktop_entry quake4-smp "Quake IV (SMP)" ${icon_path}
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use cdinstall ; then
		elog "You need to copy pak001.pk4 through pak012.pk4, along with"
		elog "zpak*.pk4 from either your installation media or your hard drive"
		elog "to ${dir}/q4base before running the game."
		echo
	fi
	if ! use dedicated ; then
		elog "To play the game, run:  quake4"
		elog
		# The default language is Spanish!
		elog "To reset the language from Spanish to English, run:"
		elog " sed -i 's:spanish:english:' ~/.quake4/q4base/Quake4Config.cfg"
		elog
		elog "Saved games from previous Quake 4 versions might not be compatible."
		elog
		elog "If you get a segmentation fault or an error regarding"
		elog "'GL_EXT_texture_compression_s3tc', you can obtain the"
		elog "necessary support for your mesa drivers by installing"
		elog "media-libs/libtxc_dxtn (for abi_x86_32 if multilib)."
		echo
	fi
	elog "To start the dedicated server, run:  quake4-ded"
}
