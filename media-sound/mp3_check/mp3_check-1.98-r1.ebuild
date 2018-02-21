# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="MP3 consistency checker"
HOMEPAGE="https://sourceforge.net/projects/mp3check/"
SRC_URI="mirror://sourceforge/mp3check/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
)

DOCS=(
	"README"
	"TODO"
	"MILESTONE"
	"MILESTONE.INTRO"
	"GOALS"
	"FOR_TESTING"
	"THANKYOU"
	"NOTES"
	"MY_NOTES"
	"WISHLIST"
)

src_install() {
	# Use dobin because Makefile doesn't support DESTDIR
	# https://sourceforge.net/p/mp3check/bugs/8/
	dobin mp3_check
	einstalldocs
}
