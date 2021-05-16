# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=f3bee47c3bce01a33b5bce88fa70bd9ecadca0ad

DESCRIPTION="Perl script to convert Ogg Vorbis files to MP3 files"
HOMEPAGE="https://github.com/fithp/ogg2mp3"
SRC_URI="https://github.com/fithp/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	dev-perl/String-ShellQuote
	media-sound/lame
	media-sound/vorbis-tools[ogg123]
"

src_install() {
	dobin ogg2mp3
	dodoc doc/{AUTHORS,ChangeLog,README,TODO}
}
