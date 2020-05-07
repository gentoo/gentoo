# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="ESR's utility for making fast comparisons among large source trees"
HOMEPAGE="http://www.catb.org/~esr/comparator/"
SRC_URI="http://www.catb.org/~esr/comparator/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="=app-text/docbook-xml-dtd-4.1.2*
	app-text/xmlto"

src_prepare() {
	sed \
		-e '/python setup.py install/d' \
		-i Makefile || die "sed failed"
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
	emake comparator.html scf-standard.html
	distutils-r1_src_compile
}

src_install() {
	emake ROOT="${D}" install
	distutils-r1_src_install
	docinto html
	dodoc *.html
}
