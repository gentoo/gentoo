# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A perl script to convert MP3 files to Ogg Vorbis files"
HOMEPAGE="http://faceprint.com/code/"
SRC_URI="ftp://ftp.faceprint.com/pub/software/scripts/mp32ogg"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-sound/mpg123
	dev-perl/MP3-Info
	dev-perl/String-ShellQuote
	media-sound/vorbis-tools"
DEPEND=""

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}/${P}-r4-mpg321.patch"
	"${FILESDIR}/${P}-r4-quality.patch"\
	"${FILESDIR}/${P}-r5-german_umlaut.patch"
	"${FILESDIR}/${P}-r6-force-filename-stringification.patch"
)

src_unpack() {
	cp -f "${DISTDIR}"/${PN} "${WORKDIR}" || die "Copying sources failed"
}

src_install() {
	dobin mp32ogg
}
