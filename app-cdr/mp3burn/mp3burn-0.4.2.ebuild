# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Burn mp3s without filling up your disk with .wav files"
HOMEPAGE="https://sourceforge.net/projects/mp3burn"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	app-cdr/cdrtools
	dev-lang/perl
	dev-perl/MP3-Info
	dev-perl/Ogg-Vorbis-Header
	dev-perl/String-ShellQuote
	media-libs/flac
	media-sound/mpg123
	media-sound/vorbis-tools
"
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
