# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

inherit fortran-2 distutils-r1 flag-o-matic multiprocessing toolchain-funcs

DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="https://www.scipy.org/"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	doc? (
		https://docs.scipy.org/doc/${P}/${PN}-html-${PV}.zip -> ${P}-html.zip
		https://docs.scipy.org/doc/${P}/${PN}-ref-${PV}.pdf -> ${P}-ref.pdf
	)"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc sparse test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-python/numpy-1.16.5[lapack,${PYTHON_USEDEP}]
	sci-libs/arpack:0=
	virtual/cblas
	virtual/lapack
	sparse? ( sci-libs/umfpack:0= )"
RDEPEND="${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]"
BDEPEND="
	dev-lang/swig
	>=dev-python/cython-0.29.13[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? ( app-arch/unzip )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

DISTUTILS_IN_SOURCE_BUILD=1

src_unpack() {
	default
	if use doc; then
		unzip -qo "${DISTDIR}"/${P}-html.zip -d html || die
	fi
}

pc_incdir() {
	$(tc-getPKG_CONFIG) --cflags-only-I $@ | \
		sed -e 's/^-I//' -e 's/[ ]*-I/:/g' -e 's/[ ]*$//' -e 's|^:||'
}

pc_libdir() {
	$(tc-getPKG_CONFIG) --libs-only-L $@ | \
		sed -e 's/^-L//' -e 's/[ ]*-L/:/g' -e 's/[ ]*$//' -e 's|^:||'
}

pc_libs() {
	$(tc-getPKG_CONFIG) --libs-only-l $@ | \
		sed -e 's/[ ]-l*\(pthread\|m\)\([ ]\|$\)//g' \
		-e 's/^-l//' -e 's/[ ]*-l/,/g' -e 's/[ ]*$//' \
		| tr ',' '\n' | sort -u | tr '\n' ',' | sed -e 's|,$||'
}

python_prepare_all() {
	# scipy automatically detects libraries by default
	export {FFTW,FFTW3,UMFPACK}=None
	use sparse && unset UMFPACK
	# the missing symbols are in -lpythonX.Y, but since the version can
	# differ, we just introduce the same scaryness as on Linux/ELF
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared
	[[ -z ${FC}  ]] && export FC="$(tc-getFC)"
	# hack to force F77 to be FC until bug #278772 is fixed
	[[ -z ${F77} ]] && export F77="$(tc-getFC)"
	export F90="${FC}"
	export SCIPY_FCONFIG="config_fc --noopt --noarch"
	append-fflags -fPIC

	local libdir="${EPREFIX}"/usr/$(get_libdir)
	cat >> site.cfg <<-EOF || die
		[blas]
		include_dirs = $(pc_incdir cblas)
		library_dirs = $(pc_libdir cblas blas):${libdir}
		blas_libs = $(pc_libs cblas blas)
		[lapack]
		library_dirs = $(pc_libdir lapack):${libdir}
		lapack_libs = $(pc_libs lapack)
	EOF
	cat >> setup.cfg <<-EOF || die
		[options]
		zip_safe = False
	EOF

	# Drop hashes to force rebuild of cython based .c code
	rm cythonize.dat || die

	# TODO
	sed -e 's:test_magic_square_sparse_no_presolve:_&:' \
		-i scipy/optimize/tests/test_linprog.py || die
	sed -e "s:== 'levy_stable':in ('levy_stable', 'crystalball', 'ncf'):" \
		-i scipy/stats/tests/test_continuous_basic.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# bug 721860
	test-flag-FC -fallow-argument-mismatch &&
		append-fflags -fallow-argument-mismatch
}

python_compile() {
	# FIXME: parallel python building fails, bug #614464
	export MAKEOPTS=-j1

	${EPYTHON} tools/cythonize.py || die
	distutils-r1_python_compile \
		${SCIPY_FCONFIG}
}

python_test() {
	# fails with bdist_egg. should it be fixed in distutils-r1 eclass?
	distutils_install_for_testing ${SCIPY_FCONFIG}
	cd "${TEST_DIR}/lib" || die "no ${TEST_DIR} available"
	PYTHONPATH=. "${EPYTHON}" -c "
import scipy, sys
r = scipy.test('fast', verbose=2)
sys.exit(0 if r else 1)" || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && \
		local DOCS=( "${DISTDIR}"/${P}-ref.pdf ) \
		local HTML_DOCS=( "${WORKDIR}"/html/. )
	distutils-r1_python_install_all
}

python_install() {
	distutils-r1_python_install ${SCIPY_FCONFIG}
	python_optimize
}

pkg_postinst() {
	elog "You might want to set the variable SCIPY_PIL_IMAGE_VIEWER"
	elog "to your prefered image viewer. Example:"
	elog "    echo \"export SCIPY_PIL_IMAGE_VIEWER=display\" >> ~/.bashrc"
}
