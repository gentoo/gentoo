# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Python package for convex optimization"
HOMEPAGE="http://cvxopt.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +dsdp examples fftw +glpk gsl"

RDEPEND="
	virtual/blas
	virtual/lapack
	sci-libs/amd:0=
	sci-libs/cholmod:0=
	sci-libs/colamd:0=
	sci-libs/suitesparseconfig:0=
	sci-libs/umfpack:0=
	dsdp? ( sci-libs/dsdp:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( >=sci-mathematics/glpk-4.49:0= )
	gsl? ( sci-libs/gsl:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

python_prepare_all(){
	pkg_libs() {
		$(tc-getPKG_CONFIG) --libs-only-l $* | \
			sed -e 's:[ ]-l*\(pthread\|m\)\([ ]\|$\)::g' -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | sed -e "s:^-l\(.*\):\1:g" | \
			tr '\n' ';' | sed -e 's:;$::'
	}
	pkg_libdir() {
		$(tc-getPKG_CONFIG) --libs-only-L $* | \
			sed -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | sed -e "s:^-L\(.*\):\1:g" | \
			tr '\n' ';' | sed -e 's:;$::'
	}
	pkg_incdir() {
		$(tc-getPKG_CONFIG) --cflags-only-I $* | \
			sed -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | sed -e "s:^-I\(.*\):\1:g" | \
			tr '\n' ';' | sed -e 's:,$::'
	}

	# mandatory dependencies
	export CVXOPT_BLAS_LIB="$(pkg_libs blas)"
	export CVXOPT_BLAS_LIB_DIR="$(pkg_libdir blas)"
	export CVXOPT_LAPACK_LIB="$(pkg_libs lapack)"
	export CVXOPT_SUITESPARSE_LIB_DIR="$(pkg_libdir umfpack cholmod amd colamd suitesparseconfig)"
	export CVXOPT_SUITESPARSE_INC_DIR="$(pkg_incdir umfpack cholmod amd colamd suitesparseconfig)"

	# optional dependencies
	use dsdp && \
		export CVXOPT_BUILD_DSDP=1 && \
		export CVXOPT_DSDP_LIB_DIR="${EPREFIX}/usr/$(get_libdir)" && \
		export CVXOPT_DSDP_INC_DIR="${EPREFIX}/usr/include"

	use fftw && \
		export CVXOPT_BUILD_FFTW=1 && \
		export CVXOPT_FFTW_LIB_DIR="$(pkg_libdir fftw3)" && \
		export CVXOPT_FFTW_INC_DIR="$(pkg_incdir fftw3)"

	use glpk && \
		export CVXOPT_BUILD_GLPK=1 && \
		export CVXOPT_GLPK_LIB_DIR="${EPREFIX}/usr/$(get_libdir)" && \
		export CVXOPT_GLPK_INC_DIR="${EPREFIX}/usr/include"

	use gsl && \
		export CVXOPT_BUILD_GSL=1 && \
		export CVXOPT_GSL_LIB_DIR="$(pkg_libdir gsl)" && \
		export CVXOPT_GSL_INC_DIR="$(pkg_incdir gsl)"

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && VARTEXFONTS="${T}/fonts" emake -C doc -B html
}

python_test() {
	PYTHONPATH="${BUILD_DIR}"/lib nosetests -v || die
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )
	insinto /usr/share/doc/${PF}
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
