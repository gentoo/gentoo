# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cdrom games

DESCRIPTION="Heavy Metal: FAKK2 - 3D third-person action shooter based on the Heavy Metal comics/movies"
HOMEPAGE="http://www.lokigames.com/products/fakk2/"
SRC_URI=""

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="x86"
IUSE="nocd"
RESTRICT="strip"

RDEPEND="virtual/opengl"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

pkg_setup() {
	games_pkg_setup
	if use nocd ; then
		ewarn "The installed game takes about 378MB of space!"
	fi
}

src_install() {
	cdrom_get_cds fakk
	einfo "Copying files... this may take a while..."
	exeinto "${dir}"
	doexe ${CDROM_ROOT}/bin/x86/glibc-2.1/${PN}
	insinto "${dir}"
	doins ${CDROM_ROOT}/{README,icon.{bmp,xpm}}
	exeinto "${dir}"/fakk
	doexe ${CDROM_ROOT}/bin/x86/glibc-2.1/fakk/{c,f}game.so
	if use nocd ; then
		insinto "${dir}"/fakk
		doins ${CDROM_ROOT}/fakk/pak{0,1,2,3}.pk3
		doins ${CDROM_ROOT}/fakk/default.cfg
	fi

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' \;

	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	newicon ${CDROM_ROOT}/icon.xpm ${PN}.xpm

	prepgamesdirs
	make_desktop_entry ${PN} "FAKK2" ${PN}
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "There are two possible security bugs in this package, both causing a denial of"
	ewarn "service.  One affects the game when running a server, the other when running as"
	ewarn "a client.  For more information, see bug #82149."
	echo
	elog "To play the game run:"
	elog " fakk2"
}
