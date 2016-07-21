# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PN="${PN/vdrgraphtft-avp/alien-vs-predator}"

DESCRIPTION="GraphTFT theme: Alien vs Predator"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Graphtft-plugin"
SRC_URI="http://www.jwendel.de/vdr/${MY_PN}-${PV}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		|| (
			>=media-plugins/vdr-graphtft-0.3.1
			media-plugins/vdr-graphtftng
		)"

S="${WORKDIR}/avp"

src_prepare() {

	# remove dead links
	cd "${S}"/columnimages
	rm {srew.png,pause.png,frew1.png,frew2.png,frew3.png,play.png,ffwd1.png,ffwd2.png,ffwd3.png,sfwd.png,recOn.png}
}

src_install() {

	insinto /usr/share/vdr/graphTFT/themes/avp/
	doins -r "${S}"/*
}
