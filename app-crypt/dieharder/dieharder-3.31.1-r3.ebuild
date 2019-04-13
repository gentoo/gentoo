# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An advanced suite for testing the randomness of RNG's"
HOMEPAGE="http://www.phy.duke.edu/~rgb/General/dieharder.php"
SRC_URI="http://www.phy.duke.edu/~rgb/General/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"
RESTRICT="test" # Way too long

RDEPEND="sci-libs/gsl"
DEPEND="${RDEPEND}
	doc? ( dev-tex/latex2html )"

DOCS=(
	NOTES
)
HTML_DOCS=()

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-urandom-64bit.patch"
)

pkg_setup() {
	use doc && DOCS+=(
		ChangeLog
		manual/dieharder.pdf manual/dieharder.ps
	)
	use doc && HTML_DOCS+=(
		dieharder.html
	)
}

src_compile() {
	emake -j1
	use doc && emake -C manual
}

src_test() {
	"${S}/dieharder/dieharder" -g 501 -a
}

src_install() {
	default

	docinto "dieharder"
	dodoc dieharder/README dieharder/NOTES
	docinto "libdieharder"
	dodoc libdieharder/README libdieharder/NOTES
}
