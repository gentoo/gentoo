# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="DVI file utilities: dvibook, dviconcat, dvitodvi, and dviselect"
HOMEPAGE="http://www.ctan.org/tex-archive/dviware/dvibook/"
# Taken from: ftp://tug.ctan.org/tex-archive/dviware/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="dvibook"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="x11-misc/imake
	x11-misc/gccmakedep
	app-text/rman"
RDEPEND=""

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}.patch"
)

src_compile() {
	xmkmf -a || die "xmkmf failed"
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install install.man
	dodoc README
}
