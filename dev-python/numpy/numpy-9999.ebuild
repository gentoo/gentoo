# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

FORTRAN_NEEDED=lapack

inherit distutils-r1 eutils flag-o-matic fortran-2 git-r3 multilib multiprocessing toolchain-funcs versionator

DOC_PV="1.9.1"
DOC_P="${PN}-${DOC_PV}"

DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="http://www.numpy.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/numpy/numpy.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="lapack test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	lapack? ( virtual/cblas virtual/lapack )"
DEPEND="${RDEPEND}
	lapack? ( virtual/pkgconfig )
	test? ( >=dev-python/nose-1.0[${PYTHON_USEDEP}] )"

# Uses distutils.command.config.
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.2-no-hardcode-blas.patch
)

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
	if use lapack; then
		append-ldflags "$($(tc-getPKG_CONFIG) --libs-only-other cblas lapack)"
		local libdir="${EPREFIX}"/usr/$(get_libdir)
		cat >> site.cfg <<-EOF
			[blas]
			include_dirs = $(pc_incdir cblas)
			library_dirs = $(pc_libdir cblas blas):${libdir}
			blas_libs = $(pc_libs cblas blas)
			[lapack]
			library_dirs = $(pc_libdir lapack):${libdir}
			lapack_libs = $(pc_libs lapack)
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

	# we don't have f2py-3.3
#	sed \
#		-e 's:test_f2py:_&:g' \
#		-i numpy/tests/test_scripts.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile -j $(makeopts_jobs) ${NUMPY_FCONFIG}
}

python_test() {
	distutils_install_for_testing ${NUMPY_FCONFIG}

	cd "${TMPDIR}" || die
	${EPYTHON} -c "
import numpy, sys
r = numpy.test(label='full', verbose=3)
sys.exit(0 if r.wasSuccessful() else 1)" || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install ${NUMPY_FCONFIG}
}

python_install_all() {
	DOCS+=( COMPATIBILITY DEV_README.txt THANKS.txt )

	distutils-r1_python_install_all

	docinto f2py
	dodoc doc/f2py/*.txt
	doman doc/f2py/f2py.1
}
