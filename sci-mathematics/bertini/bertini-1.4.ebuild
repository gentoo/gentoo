# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

MYP="BertiniSource_v${PV}"

DESCRIPTION="Software for Numerical Algebraic Geometry"
HOMEPAGE="http://bertini.nd.edu"

SRC_URI="http://www3.nd.edu/~sommese/bertini/${MYP}.tar.gz"

LICENSE="bertini"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +optimization"
DEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	dev-libs/gmp
	dev-libs/mpfr
"

S="${WORKDIR}/${MYP}/src"

src_prepare() {
	if ! use optimization; then
		sed -i -e "s/\$(OPT)/ ${CXXFLAGS} ${LDFLAGS}/" Makefile
	else
		sed -i -e "s/\$(OPT)/ \$(OPT) ${LDFLAGS}/" Makefile
	fi
	sed -i -e "s/gcc/$(tc-getCC)/" Makefile
}

src_configure() {
	:
}

src_compile() {
	emake
}

src_install() {
	dobin bertini
	if use doc; then
		dodoc "${WORKDIR}/${MYP}/BertiniUsersManual.pdf"
	fi
	if use examples; then
		insinto "/usr/share/${PN}"
		doins -r "${WORKDIR}/${MYP}/examples"
		elog "Examples have been installed into /usr/share/${MYP}"
	fi
}
