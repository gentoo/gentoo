# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools

DESCRIPTION="console app for playing FLAC audio files"
HOMEPAGE="http://flac-tools.sourceforge.net"
SRC_URI="mirror://sourceforge/flac-tools/${P}-release.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ppc ppc64 sh sparc x86"
IUSE=""

RDEPEND="dev-libs/popt
	media-libs/flac
	media-libs/libao
	media-libs/libogg"
DEPEND="${RDEPEND}"

DOCS="AUTHORS BUGS ChangeLog NEWS README*"

src_prepare() {
	eautoreconf
}
