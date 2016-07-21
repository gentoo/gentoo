# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

DESCRIPTION="dedicated server for Battlefield 1942"
HOMEPAGE="http://www.battlefield.com/battlefield-1942"
SRC_URI="http://ftp.games.skynet.be/pub/misc/${PN/-/_}-1.6-rc2.run
	http://ftp.games.skynet.be/pub/misc/bf1942-update-${PV}.tar.gz"

LICENSE="bf1942-lnxded"
SLOT="0"
KEYWORDS="x86"
IUSE=""
RESTRICT="mirror bindist strip"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/bf1942
Ddir=${D}/${dir}

QA_PREBUILT="${dir}/*.so ${dir}/bf1942_lnxded.*"

src_unpack() {
	mkdir bf1942 && cd bf1942
	unpack_makeself ${PN/-/_}-1.6-rc2.run
	cd ..
	unpack bf1942-update-${PV}.tar.gz
}

src_install() {
	dodir "${dir}"
	mv -f "${S}"/bf1942/* "${S}" || die
	rm -rf "${S}"/bf1942 || die

	mv "${S}"/* "${Ddir}" || die
	dosym bf1942_lnxded.dynamic "${dir}"/bf1942_lnxded
	games_make_wrapper ${PN} ./bf1942_lnxded "${dir}"

	prepgamesdirs
}
