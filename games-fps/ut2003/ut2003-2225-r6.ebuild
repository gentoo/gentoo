# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="Sequel to the 1999 Game of the Year multi-player first-person shooter"
HOMEPAGE="https://en.wikipedia.org/wiki/Unreal_Tournament_2003"
SRC_URI="https://ftp.snt.utwente.nl/pub/games/UT2003/Patches/Linux/${PN}lnx_patch${PV}.tar.bz2"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="dedicated"
RESTRICT="bindist mirror strip"

RDEPEND="
	!games-server/ut2003-ded
	games-fps/ut2003-data
	sys-libs/glibc
	virtual/opengl[abi_x86_32]
"

BDEPEND="app-admin/chrpath"

S="${WORKDIR}/${PN}-lnx-${PV}"
DIR="/opt/${PN}"

QA_PREBUILT="*"

src_prepare() {
	default
	chrpath -d System/{{ucc,${PN}}-bin,*.so} || die
}

src_install() {
	insinto "${DIR}"
	doins -r .
	fperms +x "${DIR}"/System/{ucc,${PN}}-bin

	make_wrapper ${PN} ./${PN}-bin "${DIR}"
	make_wrapper ${PN}-ded ./ucc "${DIR}"

	make_desktop_entry ${PN} "Unreal Tournament 2003" applications-games

	newconfd "${FILESDIR}"/${PN}-ded.confd ${PN}-ded
	newinitd "${FILESDIR}"/${PN}-ded.initd ${PN}-ded
}

pkg_postinst() {
	# Here is where we check for the existence of a cdkey.
	# If we don't find one, we ask the user for it.
	if [[ -f ${EROOT}${DIR}/System/cdkey ]] ; then
		einfo "A cdkey file is already present in ${EPREFIX}${DIR}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can (re)enter your cdkey."
	fi
	ewarn
	ewarn "If you are not installing for the first time and you plan on running"
	ewarn "a server, you will probably need to edit your"
	ewarn "~/.ut2003/System/UT2003.ini file and add a line that says"
	ewarn "AccessControlClass=crashfix.iaccesscontrolini to your"
	ewarn "[Engine.GameInfo] section to close a security issue."
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${EROOT}${DIR}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here so"
	ewarn "make sure you type it in correctly."
	ewarn "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXX-XXXX-XXXX-XXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read CDKEY1
		einfo "Please re-enter your CD key:"
		read CDKEY2
		if [[ -z ${CDKEY1} || -z ${CDKEY2} ]] ; then
			echo "You entered a blank CD key. Try again."
		else
			if [[ ${CDKEY1} == ${CDKEY2} ]] ; then
				echo "${CDKEY1^^}" > "${EROOT}${DIR}"/System/cdkey || die
				einfo "Thank you!"
				break
			else
				eerror "Your CD key entries do not match. Try again."
			fi
		fi
	done
}
