# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="HTML to text converter"
HOMEPAGE="http://www.mbayer.de/html2text/"
SRC_URI="http://www.mbayer.de/html2text/downloads/${P}.tar.gz
	http://www.mbayer.de/html2text/downloads/patch-utf8-${P}.diff
	http://www.mbayer.de/html2text/downloads/patch-amd64-${P}.diff
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

PATCHES=(
	"${FILESDIR}/${P}-compiler.patch"
	"${FILESDIR}/${P}-urlistream-get.patch"
	"${DISTDIR}/patch-utf8-${P}.diff"
	"${DISTDIR}/patch-amd64-${P}.diff"
)

src_prepare() {
	default
	gunzip html2text.1.gz html2textrc.5.gz || die
	tc-export CXX
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" DEBUG="${CXXFLAGS}"
}

src_install() {
	dobin html2text
	doman html2text.1 html2textrc.5
	dodoc CHANGES CREDITS KNOWN_BUGS README TODO
}
