# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils unpacker

DESCRIPTION="dedicated server for Battlefield 1942"
HOMEPAGE="http://www.battlefield.com/battlefield-1942"
SRC_URI="http://ftp.games.skynet.be/pub/misc/${PN/-/_}-1.6-rc2.run
	http://ftp.games.skynet.be/pub/misc/bf1942-update-${PV}.tar.gz"

LICENSE="bf1942-lnxded"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror bindist strip"

S=${WORKDIR}

dir="/opt/bf1942"
Ddir="${D}/${dir}"

QA_PREBUILT="${dir}/*.so ${dir}/bf1942_lnxded.*"

src_unpack() {
	mkdir bf1942 || die
	pushd bf1942 || die
	unpack_makeself ${PN/-/_}-1.6-rc2.run
	popd || die
	unpack bf1942-update-${PV}.tar.gz
}

src_install() {
	dodir "${dir}"
	mv -f "${S}"/bf1942/* "${S}" || die
	rm -rf "${S}"/bf1942 || die

	mv "${S}"/* "${Ddir}" || die
	dosym bf1942_lnxded.dynamic "${dir}"/bf1942_lnxded
	make_wrapper ${PN} ./bf1942_lnxded "${dir}"
}
