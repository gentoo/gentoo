# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line based audio CD ripper and mp3 encoder"
HOMEPAGE="https://rip.sourceforge.net"
SRC_URI="https://rip.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2+"
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
