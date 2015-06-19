# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cvxopt/cvxopt-1.1.6-r1.ebuild,v 1.2 2015/04/08 08:04:53 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1 toolchain-funcs eutils

DESCRIPTION="Python package for convex optimization"
HOMEPAGE="http://cvxopt.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +dsdp examples fftw +glpk gsl"

RDEPEND="
	virtual/blas
	virtual/cblas
	virtual/lapack
	sci-libs/cholmod:0=
	sci-libs/umfpack:0=
	dsdp? ( sci-libs/dsdp:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( sci-mathematics/glpk:0= )
	gsl? ( sci-libs/gsl:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

python_prepare_all(){
	local PATCHES=(	"${FILESDIR}"/${PN}-1.1.6-setup.patch )

	has_version ">=sci-mathematics/glpk-4.49" && \
		epatch "${FILESDIR}"/${PN}-1.1.6-glpk449.patch

	rm -r src/C/SuiteSparse*/ || die

	distutils-r1_python_prepare_all

	pkg_lib() {
		local libs=$($(tc-getPKG_CONFIG) --libs-only-l $1 | \
			sed -e 's:[ ]-l*\(pthread\|m\)\([ ]\|$\)::g' -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | \
			sed -e "s:^-l\(.*\):'\1':g" | \
			tr '\n' ',' | sed -e 's:,$::')
		sed -i -e "/_LIB[ ]*=/s:\(.*[ ]*=[ ]*\[\).*${1}.*:\1${libs}\]:" setup.py || die
	}

	use_cvx() {
		if use $1 ; then
			sed -i \
				-e "s/\(BUILD_${1^^} =\) 0/\1 1/" \
				setup.py || die
		fi
	}

	pkg_lib blas
	pkg_lib lapack

	# Deal with blas/lapck libraries that are not in /usr/lib{64}
	local lapackdir=\'$($(tc-getPKG_CONFIG) --libs-only-L lapack | sed \
			-e 's:^-L::' \
			-e "s:[ ]*-L:\',\':g" \
			-e 's:[ ]*$::g')\'
	sed -i -e "s:BLAS_LIB_DIR = '':BLAS_LIB_DIR = ${lapackdir}:" setup.py || die

	use_cvx gsl
	use_cvx fftw
	use_cvx glpk
	use_cvx dsdp
}

python_compile_all() {
	use doc && export VARTEXFONTS="${T}/fonts" && emake -C doc -B html
}

python_test() {
	cd examples/doc/chap8
	"${EPYTHON}" lp.py || die
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )
	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
	distutils-r1_python_install_all
}
