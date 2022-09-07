# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit virtualx

DESCRIPTION="Tcl Standard Library"
HOMEPAGE="http://www.tcl.tk/software/tcllib/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
IUSE="examples"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tdom
	"
DEPEND="${RDEPEND}"

DOCS=(
	ChangeLog DESCRIPTION.txt README.md devdoc/README.developer
	devdoc/critcl-tcllib.txt devdoc/dirlayout_install.txt
	devdoc/indexing.txt
)
HTML_DOCS=( idoc/www )

PATCHES=( "${FILESDIR}"/${P}-test.patch )

src_prepare() {
	default
	rm modules/httpd/httpd.test || die
}

src_test() {
	USER= virtx emake test_batch
}

src_install() {
	default

	if use examples ; then
		for f in $(find examples -type f); do
			docinto $(dirname $f)
			dodoc $f
		done
	fi
}
