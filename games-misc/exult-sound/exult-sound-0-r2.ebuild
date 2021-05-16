# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sound data for games-engines/exult"
HOMEPAGE="http://exult.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/exult/exult-data/exult_audio.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/exult/music
	doins music/*.ogg
	insinto /usr/share/exult/
	doins *.flx
	newdoc music/readme.txt music-readme.txt
	dodoc README_audiopack.txt readme_{jmsfx,jmsisfx,sqsfxbg,sqsfxsi}.txt
}
