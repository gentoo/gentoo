# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Console app for copying burning audio cds"
HOMEPAGE="http://www.thenktor.homepage.t-online.de/burncdda"
SRC_URI="http://www.thenktor.homepage.t-online.de/burncdda/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE="flac mp3 vorbis"

DEPEND="dev-util/dialog
	app-cdr/cdrdao
	virtual/cdrtools
	mp3? ( media-sound/mpg123
		media-sound/mp3_check )
	vorbis? ( media-sound/vorbis-tools )
	flac? ( media-libs/flac )
	media-sound/normalize
	media-sound/sox"

src_install() {
	dobin ${PN} || die "dobin failed."

	insinto /usr/lib/${PN}
	doins *.func || die "doins failed."

	insinto /etc
	doins ${PN}.conf || die "doins failed."

	dodoc CHANGELOG
	doman burncdda.1.gz
}
