# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )
PYTHON_REQ_USE="threads(+)"

FORTRAN_NEEDED=lapack

inherit distutils-r1 flag-o-matic fortran-2 multiprocessing toolchain-funcs

DOC_PV="1.16.4"
DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="https://www.numpy.org"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.zip
	doc? (
		https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-html.zip -> numpy-html-${DOC_PV}.zip
		https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-ref.pdf -> numpy-ref-${DOC_PV}.pdf
		https://numpy.org/doc/$(ver_cut 1-2 ${DOC_PV})/numpy-user.pdf -> numpy-user-${DOC_PV}.pdf
	)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc lapack test"
RESTRICT="!test? ( test )"

RDEPEND="
	lapack? (
		virtual/cblas
		virtual/lapack
	)"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	lapack? ( virtual/pkgconfig )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.17.4-no-hardcode-blasv2.patch
)

src_unpack() {
	default
	if use doc; then
		unzip -qo "${DISTDIR}"/numpy-html-${DOC_PV}.zip -d html || die
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
	if use lapack; then
		append-ldflags "$($(tc-getPKG_CONFIG) --libs-only-other cblas lapack)"
		local incdir="${EPREFIX}"/usr/include
		local libdir="${EPREFIX}"/usr/$(get_libdir)
		cat >> site.cfg <<-EOF || die
			[blas]
			blas_libs = $(pc_libs cblas blas)
			[lapack]
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

	# disable fuzzed tests
	find numpy/*/tests -name '*.py' -exec sed -i \
		-e 's:def \(.*_fuzz\):def _\1:' {} + || die
	# very memory- and disk-hungry
	sed -i -e 's:test_large_zip:_&:' numpy/lib/tests/test_io.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	export MAKEOPTS=-j1 #660754

	local python_makeopts_jobs=""
	python_is_python3 || python_makeopts_jobs="-j $(makeopts_jobs)"
	distutils-r1_python_compile \
		${python_makeopts_jobs} \
		${NUMPY_FCONFIG}
}

python_test() {
	distutils_install_for_testing --single-version-externally-managed \
		--record "${TMPDIR}/record.txt" ${NUMPY_FCONFIG}

	cd "${TMPDIR}" || die

	"${EPYTHON}" -c "
import numpy, sys
r = numpy.test(label='full', verbose=3)
sys.exit(0 if r else 1)" || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install ${NUMPY_FCONFIG}
	python_optimize
}

python_install_all() {
	local DOCS=( THANKS.txt )

	if use doc; then
		local HTML_DOCS=( "${WORKDIR}"/html/. )
		DOCS+=( "${DISTDIR}"/${PN}-{user,ref}-${DOC_PV}.pdf )
	fi

	distutils-r1_python_install_all
}
