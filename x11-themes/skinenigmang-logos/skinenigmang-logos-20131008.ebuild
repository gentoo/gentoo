# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="VDR - Skin Plugin: enigma-ng logos"
HOMEPAGE="http://andreas.vdr-developer.org/enigmang/download.html
		http://creimer.net/channellogos/"
SRC_URI="http://vdr.websitec.de/download/${PN}/enigma-logos-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="media-plugins/vdr-skinenigmang"

S=${WORKDIR}/enigmalogos

src_install() {

	insinto /usr/share/vdr/skinenigmang/
	cp -r -a "${S}"/* --target="${D}"/usr/share/vdr/skinenigmang/
}
