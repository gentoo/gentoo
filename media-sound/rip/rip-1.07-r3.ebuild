# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A command-line based audio CD ripper and mp3 encoder"
SRC_URI="http://rip.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://rip.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND=">=dev-perl/CDDB_get-2.10
	>=dev-perl/MP3-Info-0.91
	dev-lang/perl
	media-sound/cdparanoia
	sys-apps/util-linux
	|| (
		media-libs/flac
		media-sound/lame
		media-sound/vorbis-tools
	)"

PATCHES=(
	"${FILESDIR}/${P}-change-to-gnudb-org.patch"
)

src_install() {
	dobin rip
	einstalldocs
}
