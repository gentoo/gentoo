# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-symphony/coinor-symphony-5.5.7.ebuild,v 1.4 2014/02/04 10:43:38 jlec Exp $

EAPI=5

inherit autotools-utils multilib

MYPN=SYMPHONY

DESCRIPTION="COIN-OR solver for mixed-integer linear programs"
HOMEPAGE="https://projects.coin-or.org/SYMPHONY/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples glpk static-libs test"

RDEPEND="
	sci-libs/coinor-cgl:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-dylp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	sci-libs/coinor-vol:=
	glpk? ( sci-mathematics/glpk:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# needed for the --with-coin-instdir
	dodir /usr
	sed -i \
		-e "s:lib/pkgconfig:$(get_libdir)/pkgconfig:g" \
		configure || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-dependency-linking
		--with-coin-instdir="${ED}"/usr
	)
	if use glpk; then
		myeconfargs+=(
			--with-glpk-incdir="${EPREFIX}"/usr/include
			--with-glpk-lib=-lglpk )
	else
		myeconfargs+=( --without-glpk )
	fi
	autotools-utils_src_configure
}

src_compile() {
	# hack for parallel build, to overcome not patching Makefile.am above
	autotools-utils_src_compile -C src libSym.la
	autotools-utils_src_compile
	if use doc; then
		pushd Doc /dev/null
		pdflatex Walkthrough && pdflatex Walkthrough
		# does not compile and doc is online
		#pdflatex man && pdflatex man
		popd > /dev/null
	fi
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	# hack for parallel install, to overcome not patching Makefile.am above
	autotools-utils_src_install -C src install-am
	autotools-utils_src_install
	use doc && dodoc Doc/Walkthrough.pdf
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r Examples/*
	fi
}
