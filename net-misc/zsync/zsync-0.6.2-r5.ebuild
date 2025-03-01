# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Partial/differential file download client over HTTP using the rsync algorithm"
HOMEPAGE="http://zsync.moria.org.uk/"
SRC_URI="
	http://zsync.moria.org.uk/download/${P}.tar.bz2
"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.2-musl-off_t-fix.patch
	"${FILESDIR}"/${PN}-0.6.2-c99.patch
	"${FILESDIR}"/${PN}-0.6.2-unbundle-zlib.patch
	"${FILESDIR}"/${PN}-0.6.2-warning-fixes.patch
)

src_prepare() {
	default

	# Drop bundled zlib
	rm -r zlib || die

	eautoreconf
}

src_install() {
	dobin zsync zsyncmake
	dodoc NEWS README
	doman doc/zsync.1 doc/zsyncmake.1
}
