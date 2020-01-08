# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Molecular dynamics simulations platform"
HOMEPAGE="http://www.ccp5.ac.uk/moldy/moldy.html"
SRC_URI="ftp://ftp.earth.ox.ac.uk/pub/keith/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples"

DEPEND="doc? ( virtual/latex-base )"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-as-needed.patch
	sed \
		-e 's:-O2::g' \
		-e 's:-ffast-math::g' \
		-i configure || die
}

src_configure() {
	#Individuals may want to edit the OPT* variables below.
	#From the READ.ME:
	#You may need to  "hand-tune" compiler or optimization options,
	#which may be specified by setting the OPT and OPT2 environment
	#variables.  OPT2 is used to compile only the most performance-critical
	#modules and usually will select a very high level of optimization.
	#It should be safe to select an optimization which means "treat all
	#function arguments as restricted pointers which are not aliased to
	#any other object".  OPT is used for less preformance-critical modules
	#and may be set to a lower level of optimization than OPT2.

	OPT="${CFLAGS}" \
	OPT2="${CFLAGS} ${CFLAGS_OPT}" \
	CC=$(tc-getCC) \
	econf
}

src_compile() {
	emake
	# To prevent sandbox violations by metafont
	if use doc; then
		VARTEXFONTS="${T}"/fonts emake moldy.pdf
	fi
}

src_install() {
	dodir /usr/bin
	emake prefix="${ED}"/usr install
	dodoc BENCHMARK READ.ME RELNOTES

	if use examples; then
		rm Makefile.in configure.in config.h.in
		insinto /usr/share/${PN}/examples/
		doins *.in *.out control.*
	fi
	if use doc; then
		insinto /usr/share/doc/${PF}/pdf
		newins moldy.pdf moldy-manual.pdf
	fi
}
