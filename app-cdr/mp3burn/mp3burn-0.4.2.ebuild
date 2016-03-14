# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Burn mp3s without filling up your disk with .wav files"
HOMEPAGE="http://sourceforge.net/projects/mp3burn"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	media-sound/mpg123
	media-libs/flac
	media-sound/vorbis-tools
	virtual/cdrtools
	dev-perl/MP3-Info
	dev-perl/Ogg-Vorbis-Header
	dev-perl/String-ShellQuote
"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
