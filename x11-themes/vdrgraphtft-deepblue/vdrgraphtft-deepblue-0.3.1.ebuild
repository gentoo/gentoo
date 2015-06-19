# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/vdrgraphtft-deepblue/vdrgraphtft-deepblue-0.3.1.ebuild,v 1.2 2014/02/21 21:41:32 hd_brummy Exp $

EAPI=5

inherit eutils

MY_PN="${PN/vdrgraphtft-deepblue/DeepBlue-horchi}"

DESCRIPTION="GraphTFT theme: Deep Blue"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Graphtft-plugin"
SRC_URI="http://www.jwendel.de/vdr/${MY_PN}-${PV}.tar.bz2
		http://vdr.websitec.de/download/${PN}/vdr-graphtftng-0.4.7_DeepBlue.theme.bz2"

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

S="${WORKDIR}/DeepBlue"

src_install() {

	insinto /usr/share/vdr/graphTFT/themes/DeepBlue/
	doins -r "${S}"/*

	if has_version ">=media-plugins/vdr-graphtftng-0.4.7"; then
		newins "${WORKDIR}/vdr-graphtftng-0.4.7_DeepBlue.theme" DeepBlue.theme
	fi
}
