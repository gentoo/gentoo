# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2003/ut2003-2225-r4.ebuild,v 1.18 2015/06/14 18:15:46 ulm Exp $

EAPI=5

inherit eutils games

DESCRIPTION="Sequel to the 1999 Game of the Year multi-player first-person shooter"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="ftp://ftp.infogrames.net/misc/ut2003/ut2003lnx_patch2225.tar.tar"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated"
RESTRICT="strip"

RDEPEND="
	games-fps/ut2003-data
	dedicated? ( games-server/ut2003-ded )
	!dedicated? ( virtual/opengl[abi_x86_32(-)] )
"
DEPEND=""

S=${WORKDIR}

dir="${GAMES_PREFIX_OPT}/${PN}"
Ddir="${D}/${dir}"

src_unpack() {
	unpack ut2003lnx_patch${PV}.tar.tar
}

src_install() {
	insinto "${dir}"

	games_make_wrapper ut2003 ./ut2003 "${dir}" "${dir}"
	make_desktop_entry ut2003 "Unreal Tournament 2003" ut2003

	# TODO: change this to use doexe/doins
	# this brings our install up to the newest version
	cp -r "${S}"/ut2003-lnx-2225/* "${Ddir}" || die

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	# here is where we check for the existence of a cdkey...
	# if we don't find one, we ask the user for it
	if [[ -f "${dir}"/System/cdkey ]] ; then
		elog "A cdkey file is already present in ${dir}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can (re)enter your cdkey."
	fi
	elog
	elog "To play the game run:"
	elog " ut2003"
	ewarn
	ewarn "If you are not installing for the first time and you plan on running"
	ewarn "a server, you will probably need to edit your"
	ewarn "~/.ut2003/System/UT2003.ini file and add a line that says"
	ewarn "AccessControlClass=crashfix.iaccesscontrolini to your"
	ewarn "[Engine.GameInfo] section to close a security issue."
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${dir}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here."
	ewarn "  Make sure you type it in correctly."
	eerror "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXX-XXXX-XXXX-XXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read CDKEY1
		einfo "Please re-enter your CD key:"
		read CDKEY2
		if [[ "${CDKEY1}" == "" ]] ; then
			echo "You entered a blank CD key.  Try again."
		else
			if [[ "${CDKEY1}" == "${CDKEY2}" ]] ; then
				echo "${CDKEY1}" | tr a-z A-Z > ${dir}/System/cdkey
				einfo "Thank you!"
				chown games:games "${dir}"/System/cdkey
				break
			else
				eerror "Your CD key entries do not match.  Try again."
			fi
		fi
	done
}
