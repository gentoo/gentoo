# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="An advanced suite for testing the randomness of RNGs"
HOMEPAGE="https://www.phy.duke.edu/~rgb/General/dieharder.php"
SRC_URI="https://www.phy.duke.edu/~rgb/General/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"
RESTRICT="test" # Way too long

RDEPEND="sci-libs/gsl"
DEPEND="${RDEPEND}"
BDEPEND=" doc? ( dev-tex/latex2html )"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-urandom-64bit.patch
	"${FILESDIR}"/${P}-cross-compile.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fcommon
	econf --disable-static
}

src_compile() {
	emake -j1
	use doc && emake -C manual
}

src_install() {
	if use doc; then
		DOCS=( ChangeLog manual/dieharder.pdf manual/dieharder.ps )
		HTML_DOCS=( dieharder.html )
	fi

	default

	docinto dieharder
	dodoc dieharder/{NOTES,README}
	docinto libdieharder
	dodoc libdieharder/{NOTES,README}

	find "${ED}" -name '*.la' -delete || die
}
