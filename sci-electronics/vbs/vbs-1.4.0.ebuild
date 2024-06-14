# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="vbs - the Verilog Behavioral Simulator"
HOMEPAGE="http://www.geda.seul.org/tools/vbs/index.html"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-alternatives/lex
	app-alternatives/yacc"
RDEPEND=""

S="${WORKDIR}/${P}/src"
PATCHES=(
	"${FILESDIR}"/${P}-gcc-4.1.patch
	"${FILESDIR}"/${P}-gcc-4.3.patch
	"${FILESDIR}"/${P}-const_cast.patch
)

src_compile() {
	emake -j1 vbs
}

src_install() {
	dobin vbs
	cd .. || die

	einstalldocs
	dodoc CHANGELOG* CONTRIBUTORS vbs.txt

	insinto /usr/share/${PF}/examples
	doins -r EXAMPLES/.
}
