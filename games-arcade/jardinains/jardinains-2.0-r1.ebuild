# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/jardinains/jardinains-2.0-r1.ebuild,v 1.6 2015/06/01 21:40:34 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Arkanoid with Gnomes"
HOMEPAGE="http://www.jardinains2.com"
SRC_URI="mirror://gentoo/JN2_1_FREE_LIN.tar.gz"

LICENSE="jardinains"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"
QA_EXECSTACK="${GAMES_PREFIX_OPT:1}/jardinains/jardinains"

DEPEND=""
RDEPEND="sys-libs/libstdc++-v3:5
	amd64? ( sys-libs/libstdc++-v3:5[multilib] )
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=virtual/glu-9.0-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXxf86vm-1.1.3[abi_x86_32(-)]"

dir=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${dir:1}/${PN}"

src_unpack() {
	unpack JN2_1_FREE_LIN.tar.gz
	cd "${WORKDIR}" || die
	mv "Jardinains 2!" ${P} || die
}

src_prepare() {
	# clean Mac fork files (bug #295782)
	find . -type f -name "._*" -exec rm -f '{}' +
	epatch "${FILESDIR}"/strings-pt.patch
}

src_install() {
	exeinto "${dir}"
	doexe jardinains
	insinto "${dir}"
	doins -r LICENSE.txt data help

	games_make_wrapper jardinains ./jardinains "${dir}" "${dir}"

	make_desktop_entry jardinains "Jardinains 2"
	touch "${D}${dir}/data/prefs.xml"
	prepgamesdirs
	chmod g+rw "${D}${dir}/data/prefs.xml"
	chmod -R g+rw "${D}${dir}/data/players"
}

pkg_postinst() {
	games_pkg_postinst
	elog "Due to the way this software is designed all user preferences for"
	elog "graphics, audio and other in game data are shared among all users"
	elog "of the computer. For that reason some files in the installation"
	elog "folder are writable by any user in the games group."
}
