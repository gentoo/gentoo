# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Calculator of perceived sound level for Ogg Vorbis files"
HOMEPAGE="https://sjeng.org/vorbisgain.html"
SRC_URI="https://sjeng.org/ftp/vorbis/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	media-libs/libogg
	media-libs/libvorbis"
DEPEND="${RDEPEND}"

PATCHES=(
	# bug 200931
	"${FILESDIR}"/${P}-fix-errno-and-warnings.patch
	# bug 634994
	"${FILESDIR}"/${P}-wformat-security.patch
)

src_configure() {
	econf --enable-recursive
}

src_install() {
	default
	dodoc vorbisgain.txt
}
