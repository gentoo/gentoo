# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit virtualx

DESCRIPTION="Tcl Standard Library"
HOMEPAGE="http://www.tcl.tk/software/tcllib/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
IUSE="examples"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tdom
	"
DEPEND="${RDEPEND}"

DOCS=(
	ChangeLog DESCRIPTION.txt README-1.19.txt README.developer
	devdoc/critcl-tcllib.txt devdoc/dirlayout_install.txt
	devdoc/indexing.txt devdoc/installation.txt
)
HTML_DOCS=( devdoc/devguide.html devdoc/releaseguide.html )

src_prepare() {
	default
	if has_version ">=dev-lang/tcl-8.6.9"; then
		sed -i \
			-e "s|::hook::call|call|" \
			-e "s|::string::token::shell|shell|" \
			"${S}"/modules/hook/hook.test \
			"${S}"/modules/string/token_shell.test \
			|| die
	fi
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
