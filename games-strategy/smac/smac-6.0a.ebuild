# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/smac/smac-6.0a.ebuild,v 1.25 2015/03/26 20:21:43 mr_bones_ Exp $

EAPI=5
inherit eutils unpacker cdrom games

DESCRIPTION="Linux port of the popular strategy game from Firaxis"
HOMEPAGE="http://www.lokigames.com/products/smac/"
SRC_URI="x86? ( mirror://lokigames/${PN}/${P}-x86.run )
	amd64? ( mirror://lokigames/${PN}/${P}-x86.run )
	ppc? ( http://mirrors.dotsrc.org/lokigames/installers/${PN}/${PN}-install-ppc.run )"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+videos"
RESTRICT="strip"

DEPEND="games-util/loki_patch"
RDEPEND="sys-libs/glibc
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	!ppc? ( sys-libs/lib-compat-loki )
	media-libs/libsdl[sound,video]
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	media-libs/smpeg
	media-libs/freetype
	sys-libs/zlib"

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	cdrom_get_cds Alien_Crossfire_Manual.pdf
	mkdir -p "${S}"/a
	cd "${S}"/a
	use x86 || use amd64 && unpack_makeself ${P}-x86.run
	use ppc && unpack_makeself ${PN}-install-ppc.run
}

src_install() {
	einfo "Copying files... this may take a while..."
	exeinto "${dir}"
	doexe "${CDROM_ROOT}"/bin/x86/{smac,smacx,smacpack}

	insinto "${dir}"
	doins ${CDROM_ROOT}/{{Alien_Crossfire,Alpha_Centauri}_Manual.pdf,QuickStart.txt,README,icon.{bmp,xpm}}

	cd "${Ddir}"
	tar xzf "${CDROM_ROOT}"/data.tar.gz || die
	insinto "${dir}"/data
	doins "${CDROM_ROOT}"/data/*.{pcx,cvr,flc,gif}
	doins -r "${CDROM_ROOT}"/data/{facs,fx,projs,techs,voices}

	if use videos ; then
		doins -r "${CDROM_ROOT}"/data/movies
	fi

	cd "${S}"/a
	if use ppc ; then
		cd ${P}-ppc
	fi
	loki_patch --verify patch.dat
	loki_patch patch.dat "${Ddir}" >& /dev/null || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' +

	newicon "${CDROM_ROOT}"/icon.xpm smac.xpm

	games_make_wrapper ${PN}pack ./${PN}pack "${dir}" "${dir}"
	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	games_make_wrapper ${PN}x ./${PN}x "${dir}" "${dir}"
	make_desktop_entry smacpack "Sid Meier's SMAC Planetary Pack" smacpack
	make_desktop_entry smac "Sid Meier's Alpha Centauri" smac
	make_desktop_entry smacx "Sid Meier's Alpha Centauri - Alien Crossfire" smac
	prepgamesdirs

	if use x86 || use amd64 ; then
	    einfo "Linking libs provided by 'sys-libs/lib-compat-loki' to '${dir}'."
	    dosym /lib/loki_ld-linux.so.2 "${dir}"/ld-linux.so.2 && \
	    dosym /usr/lib/loki_libc.so.6 "${dir}"/libc.so.6 && \
	    dosym /usr/lib/loki_libnss_files.so.2 "${dir}"/libnss_files.so.2
	fi
}

pkg_postinst() {
	games_pkg_postinst
	elog "To start Sid Meyer's SMAC Planetary Pack run:"
	elog " smac"
	elog "To play Sid Meyer's Alpha Centauri run:"
	elog " smac"
	elog "To play Alien Crossfire run:"
	elog " smacx"
	elog "Be sure to enable CONFIG_UID16 in your kernel config or"
	elog "the game will error." # bug 340303
}
