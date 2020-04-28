# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sound data for games-engines/exult"
HOMEPAGE="http://exult.sourceforge.net/"
SRC_URI="mirror://sourceforge/exult/exult_audio.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!<games-engines/exult-9999
	app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/exult/music
	doins music/*.ogg
	insinto /usr/share/exult/
	doins *.flx
	newdoc music/readme.txt music-readme.txt
	dodoc README_audiopack.txt readme_{jmsfx,jmsisfx,sqsfxbg,sqsfxsi}.txt
}
