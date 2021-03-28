# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"

FORTRAN_NEEDED=lapack

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 flag-o-matic fortran-2 multiprocessing toolchain-funcs

DOC_PV="1.16.4"
DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="https://numpy.org/"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.zip
	doc? (
		https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-html.zip -> numpy-html-${DOC_PV}.zip
		https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-ref.pdf -> numpy-ref-${DOC_PV}.pdf
		https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-user.pdf -> numpy-user-${DOC_PV}.pdf
	)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc lapack"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	app-arch/unzip
	>=dev-python/cython-0.29.21[${PYTHON_USEDEP}]
	lapack? ( virtual/pkgconfig )
	test? (
		>=dev-python/hypothesis-5.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
		>=dev-python/cffi-1.14.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/numpy-1.20.1-no-hardcode-blasv2.patch
	"${FILESDIR}"/numpy-1.20.2-fix-ccompiler-tests.patch
)

distutils_enable_tests pytest

src_unpack() {
	default
	if use doc; then
		unzip -qo "${DISTDIR}"/numpy-html-${DOC_PV}.zip -d html || die
	fi
}

python_prepare_all() {
	if use lapack; then
		local incdir="${EPREFIX}"/usr/include
		local libdir="${EPREFIX}"/usr/$(get_libdir)
		cat >> site.cfg <<-EOF || die
			[blas]
			include_dirs = ${incdir}
			library_dirs = ${libdir}
			blas_libs = cblas,blas
			[lapack]
			library_dirs = ${libdir}
			lapack_libs = lapack
		EOF
	else
		export {ATLAS,PTATLAS,BLAS,LAPACK,MKL}=None
	fi

	export CC="$(tc-getCC) ${CFLAGS}"

	append-flags -fno-strict-aliasing

	# See progress in http://projects.scipy.org/scipy/numpy/ticket/573
	# with the subtle difference that we don't want to break Darwin where
	# -shared is not a valid linker argument
	if [[ ${CHOST} != *-darwin* ]]; then
		append-ldflags -shared
	fi

	# only one fortran to link with:
	# linking with cblas and lapack library will force
	# autodetecting and linking to all available fortran compilers
	append-fflags -fPIC
	if use lapack; then
		NUMPY_FCONFIG="config_fc --noopt --noarch"
		# workaround bug 335908
		[[ $(tc-getFC) == *gfortran* ]] && NUMPY_FCONFIG+=" --fcompiler=gnu95"
	fi

	# don't version f2py, we will handle it.
	sed -i -e '/f2py_exe/s: + os\.path.*$::' numpy/f2py/setup.py || die

	# disable fuzzed tests
	find numpy/*/tests -name '*.py' -exec sed -i \
		-e 's:def \(.*_fuzz\):def _\1:' {} + || die
	# very memory- and disk-hungry
	sed -i -e 's:test_large_zip:_&:' numpy/lib/tests/test_io.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	export MAKEOPTS=-j1 #660754

	distutils-r1_python_compile ${NUMPY_FCONFIG}
}

python_test() {
	distutils_install_for_testing --single-version-externally-managed \
		--record "${TMPDIR}/record.txt" ${NUMPY_FCONFIG}

	cd "${TEST_DIR}/lib" || die
	epytest \
		--deselect 'numpy/typing/tests/test_typing.py::test_fail[array_constructors.py]'
}

python_install() {
	# https://github.com/numpy/numpy/issues/16005
	local mydistutilsargs=( build_src )
	distutils-r1_python_install ${NUMPY_FCONFIG}
	python_optimize
}

python_install_all() {
	local DOCS=( LICENSE.txt README.md THANKS.txt )

	if use doc; then
		local HTML_DOCS=( "${WORKDIR}"/html/. )
		DOCS+=( "${DISTDIR}"/${PN}-{user,ref}-${DOC_PV}.pdf )
	fi

	distutils-r1_python_install_all
}
