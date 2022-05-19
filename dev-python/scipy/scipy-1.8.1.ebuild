# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit fortran-2 distutils-r1 flag-o-matic multiprocessing toolchain-funcs

# Upstream is often behind with doc updates
DOC_PV=1.8.1
DESCRIPTION="Scientific algorithms library for Python"
HOMEPAGE="
	https://scipy.org/
	https://github.com/scipy/scipy/
	https://pypi.org/project/scipy/
"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	doc? (
		https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-html-${DOC_PV}.zip
		https://docs.scipy.org/doc/${PN}-${DOC_PV}/${PN}-ref-${DOC_PV}.pdf
	)"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 -hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc +pythran sparse"

DEPEND="
	>=dev-python/numpy-1.17.3[lapack,${PYTHON_USEDEP}]
	sci-libs/arpack:0=
	virtual/cblas
	virtual/lapack
	sparse? ( sci-libs/umfpack:0= )"
RDEPEND="${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]"
BDEPEND="
	dev-lang/swig
	>=dev-python/cython-0.29.18[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? ( app-arch/unzip )
	pythran? ( dev-python/pythran[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_unpack() {
	default

	if use doc; then
		unzip -qo "${DISTDIR}"/${PN}-html-${DOC_PV}.zip -d html || die
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

	# TODO
	sed -e "s:== 'levy_stable':in ('levy_stable', 'crystalball', 'ncf'):" \
		-i scipy/stats/tests/test_continuous_basic.py || die

	# Skip known-failing test. Broken on all versions in Gentoo for years.
	# bug #743295
	sed -e 's:test_bisplev_integer_overflow:_&:' \
			-i scipy/interpolate/tests/test_fitpack.py || die

	# Skip a few 32-bit related failures
	if use x86 ; then
		# TODO: Tidy this up and switch to epytest
		sed -i -e 's:test_nd_axis_m1:_&:' \
			-e 's:test_nd_axis_0:_&:' \
			-e 's:test_maxiter_worsening:_&:' \
			-e 's:test_pdist_jensenshannon_iris:_&:' \
			-e 's:test_align_vectors_single_vector:_&:' \
			scipy/signal/tests/test_spectral.py \
			scipy/spatial/tests/test_distance.py \
			scipy/spatial/transform/tests/test_rotation.py || die
	fi

	if has_version ">=sci-libs/lapack-3.10"; then
		sed -e 's:test_sort(:_&:' \
			-i scipy/linalg/tests/test_decomp.py || die
		sed -e 's:test_solve_discrete_are:_&:' \
			-i scipy/linalg/tests/test_solvers.py || die
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
	export SCIPY_USE_PYTHRAN=$(usex pythran 1 0)

	# bug 721860
	test-flag-FC -fallow-argument-mismatch &&
		append-fflags -fallow-argument-mismatch
}

python_compile() {
	# FIXME: parallel python building fails, bug #614464
	export ORIGINAL_MAKEOPTS="${MAKEOPTS}"
	export MAKEOPTS=-j1

	${EPYTHON} tools/cythonize.py || die
	distutils-r1_python_compile \
		${SCIPY_FCONFIG}
}

python_test() {
	# fails with bdist_egg. should it be fixed in distutils-r1 eclass?
	distutils_install_for_testing ${SCIPY_FCONFIG}
	cd "${TEST_DIR}/lib" || die "no ${TEST_DIR} available"

	# Let's try using pytest again with xdist to speed things up.
	# Note that using pytest is required to avoid dying b/c of a
	# deprecation warning with distutils in Python 3.01.
	epytest -n "$(makeopts_jobs "${ORIGINAL_MAKEOPTS}" "$(get_nproc)")"
}

python_install_all() {
	use doc && \
		local DOCS=( "${DISTDIR}"/${PN}-ref-${DOC_PV}.pdf ) \
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
