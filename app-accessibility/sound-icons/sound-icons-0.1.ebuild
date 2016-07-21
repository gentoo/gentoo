# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="a collection of Sound Icons for speech-dispatcher"
HOMEPAGE="http://www.freebsoft.org"
SRC_URI="http://www.freebsoft.org/pub/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="app-accessibility/speech-dispatcher"

src_compile(){
	einfo "Nothing to compile."
}

src_install() {
	dodoc README
	insinto /usr/share/sounds/sound-icons
	doins "${S}"/*.wav
	links="`find ${S} -type l -print`"
	for link in $links; do
		target=`readlink -n $link`
		dosym $target /usr/share/sounds/sound-icons/`basename $link`
	done
}
