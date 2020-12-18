# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Console app for copying burning audio cds"
HOMEPAGE="http://burncdda.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="flac mp3 vorbis"

RDEPEND="
	app-cdr/cdrdao
	app-cdr/cdrtools
	dev-util/dialog
	media-sound/normalize
	media-sound/sox
	flac? ( media-libs/flac )
	mp3? (
		media-sound/mpg123
		media-sound/mp3_check
	)
	vorbis? ( media-sound/vorbis-tools )
"

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins *.func

	insinto /etc
	doins ${PN}.conf

	dodoc ChangeLog
	doman burncdda.1
}
