# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CDROM_OPTIONAL="yes"
inherit eutils unpacker cdrom games

DESCRIPTION="Quake III Arena - data portion"
HOMEPAGE="http://icculus.org/quake3/"
SRC_URI="mirror://idsoftware/quake3/linux/linuxq3apoint-${PV}-3.x86.run"

LICENSE="Q3AEULA"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}
dir=${GAMES_DATADIR}/quake3

src_unpack() {
	use cdinstall && cdrom_get_cds baseq3/pak0.pk3:Quake3/baseq3/pak0.pk3
	unpack_makeself
}

src_install() {
	ebegin "Copying files from linux client ..."
	insinto "${GAMES_DATADIR}"/quake3/baseq3
	doins baseq3/*.pk3
	eend 0

	if use cdinstall ; then
		einfo "Copying files from CD ..."
		newins "${CDROM_ABSMATCH}" pak0.pk3
		eend 0
	fi

	find "${D}" -exec touch '{}' \;

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use cdinstall ; then
		echo
		elog "You need to copy pak0.pk3 from your Quake3 CD into:"
		elog " ${dir}/baseq3."
		elog "Or if you have a Windows installation of Q3 make a symlink to save space."
		elog
		elog "Or, re-emerge quake3-data with USE=cdinstall."
		echo
	fi
}
