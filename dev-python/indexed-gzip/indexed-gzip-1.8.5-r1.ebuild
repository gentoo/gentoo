# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multiprocessing pypi

DESCRIPTION="Fast random access of gzip files in Python"
HOMEPAGE="
	https://pypi.org/project/indexed-gzip/
	https://github.com/pauldmccarthy/indexed_gzip/
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# strip custom "clean" command that doesn't support "-a"
	# https://bugs.gentoo.org/838955
	# TODO: this can be removed once distutils-r1 stops using clean
	sed -e '/cmdclass/d' -i setup.py || die
	distutils-r1_src_prepare
}

src_compile() {
	# This actually enables line tracing, so it fits USE=debug more.
	if use debug; then
		export INDEXED_GZIP_TESTING=1
	fi
	# Fix implicit dependency on numpy that is used to build test
	# extensions.
	if ! use test; then
		local -x PYTHONPATH="${T}:${PYTHONPATH}"
		cat >> "${T}"/numpy.py <<-EOF || die
			raise ImportError("I am not here!")
		EOF
	fi
	distutils-r1_src_compile
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)/indexed_gzip/tests" || die
	epytest -n "$(makeopts_jobs)" --dist=worksteal
	# temporary files and test extensions
	# (to achieve equivalence with USE=-test)
	rm ctest*.{c,gz,so,tmp} || die
}
