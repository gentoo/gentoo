# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cdrom games

MY_PV=${PV/./}
SOW="descent2.sow"

DESCRIPTION="Data files for Descent 2"
HOMEPAGE="http://www.interplay.com/games/product.asp?GameID=109"
SRC_URI=""
# Don't have a method of applying the ver 1.2 patch in Linux
# http://www.interplay.com/support/product.asp?GameID=109
# mirror://3dgamers/descent2/d2ptch${MY_PV}.exe

# See readme.txt
LICENSE="${PN}"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="videos"

# d2x-0.2.5-r2 may include the CD data itself.
# d2x-0.2.5-r3 does not include the CD data.
# d2x-rebirth is favoured because it is stable.
#RDEPEND="|| (
#	games-action/d2x-rebirth
#	>=games-action/d2x-0.2.5-r3 )"
RDEPEND="!<games-action/d2x-0.2.5-r3"
DEPEND="app-arch/unarj"

S=${WORKDIR}
dir=${GAMES_DATADIR}/d2x

pkg_setup() {
	games_pkg_setup

	local m f need_cd="n"

	# Could have the ${SOW} file in ${DISTDIR}
	if [[ -e "${DISTDIR}/${SOW}" ]] ; then
		einfo "Using ${SOW} from ${DISTDIR}"
		# Check that the movies are available in ${DISTDIR} if needed
		if use videos ; then
			for m in {intro,other,robots}-{h,l}.mvl ; do
				[[ -e "${DISTDIR}/${m}" ]] || need_cd="y"
			done
		fi
	else
		need_cd="y"
	fi

	if [[ "${need_cd}" == "y" ]] ; then
		# The Descent 2 CD is needed
		cdrom_get_cds "d2data/${SOW}"
	fi
}

src_unpack() {
	local m f="${DISTDIR}/${SOW}"

	[[ -e "${f}" ]] || f="${CDROM_ROOT}/d2data/${SOW}"
	# Extract level data
	unarj e "${f}" || die

	if use videos ; then
		# Include both high and low resolution movie files
		for m in {intro,other,robots}-{h,l}.mvl ; do
			f="${DISTDIR}/${m}"
			[[ -e "${f}" ]] || f="${CDROM_ROOT}/d2data/${m}"
			einfo "Copying ${m}"
			cp -f "${f}" . || die
		done
	fi

	rm -f endnote.txt
	mkdir doc
	mv -f *.txt doc

	# Remove files not needed by any Linux native client
	rm -f *.{bat,dll,exe,ini,lst}
}

src_install() {
	insinto "${dir}"
	doins *

	dodoc doc/*

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "A client is needed to run the game, e.g. games-action/d2x-rebirth."
	echo
}
