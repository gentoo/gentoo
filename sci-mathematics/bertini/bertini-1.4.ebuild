# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

MYP="BertiniSource_v${PV}"
DESCRIPTION="Software for Numerical Algebraic Geometry"
HOMEPAGE="http://bertini.nd.edu"
SRC_URI="http://www3.nd.edu/~sommese/bertini/${MYP}.tar.gz"
S="${WORKDIR}/${MYP}/src"

LICENSE="bertini"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +optimization"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="
	dev-libs/gmp
	dev-libs/mpfr
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# bug #723328
	append-cflags -fcommon

	# Ensure this is before the CFLAGS sed
	# or breakage occurs if 'gcc' is in your CFLAGS
	sed -i -e "s/gcc/$(tc-getCC)/" Makefile || die

	if ! use optimization; then
		sed -i -e "s/\$(OPT)/ ${CFLAGS} ${CXXFLAGS} ${LDFLAGS}/" Makefile || die
	else
		# If people want the optimisation offered by upstream,
		# let's ensure they don't accidentally override it.
		filter-flags -O?
		sed -i -e "s/\$(OPT)/ \$(OPT) ${CFLAGS} ${LDFLAGS}/" Makefile || die
	fi
}

src_install() {
	dobin bertini

	if use doc; then
		dodoc "${WORKDIR}/${MYP}/BertiniUsersManual.pdf"
	fi

	if use examples; then
		docinto examples
		dodoc -r "${WORKDIR}/${MYP}/examples"
		elog "Examples have been installed into /usr/share/${MYP}"
	fi
}
