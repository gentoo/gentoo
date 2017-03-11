# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Calculator of perceived sound level for Ogg Vorbis files"
HOMEPAGE="http://sjeng.org/vorbisgain.html"
SRC_URI="http://sjeng.org/ftp/vorbis/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	media-libs/libogg
	media-libs/libvorbis"
DEPEND="${RDEPEND}"

PATCHES=(
	# bug 200931
	"${FILESDIR}"/${P}-fix-errno-and-warnings.patch
)
DOCS=( NEWS README vorbisgain.txt )

src_configure() {
	econf --enable-recursive
}
