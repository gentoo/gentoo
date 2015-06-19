# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/ja2-stracciatella-data/ja2-stracciatella-data-1.ebuild,v 1.4 2012/11/21 10:13:21 ago Exp $

EAPI=4

inherit cdrom check-reqs games

DESCRIPTION="A port of Jagged Alliance 2 to SDL (data files)"
HOMEPAGE="http://tron.homeunix.org/ja2/"
SRC_URI=""

LICENSE="SIR-TECH"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-strategy/ja2-stracciatella"
DEPEND="app-arch/unshield"

S=${WORKDIR}

CHECKREQS_DISK_BUILD="3G"
CHECKREQS_DISK_USR="1G"

src_unpack() {
	export CDROM_NAME="INSTALL_CD"

	cdrom_get_cds INSTALL/data1.cab

	# this makes some serious overhead
	unshield x "${CDROM_ROOT}"/INSTALL/data1.cab || die "unpacking failed"
}

src_prepare() {
	cd "${S}"/Ja2_Files/Data || die
	local lower i

	# convert to lowercase
	find . \( -iname "*.jsd" -o -iname "*.wav" -o -iname "*.sti" -o -iname "*.slf" \) \
		-exec sh -c 'echo "${1}"
	lower="`echo "${1}" | tr [:upper:] [:lower:]`"
	[ -d `dirname "${lower}"` ] || mkdir `dirname ${lower}`
	[ "${1}" = "${lower}" ] || mv "${1}" "${lower}"' - {} \;

	# remove possible leftover
	rm -r ./TILECACHE ./STSOUNDS
}

src_install() {
	insinto "${GAMES_DATADIR}"/ja2/data
	doins -r "${S}"/Ja2_Files/Data/*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "This is just the data portion of the game. You will need to install"
	elog "games-strategy/ja2-stracciatella to play the game."
}
