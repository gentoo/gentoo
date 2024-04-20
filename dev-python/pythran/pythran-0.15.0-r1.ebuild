# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( pypy3 python3_{10..12} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Ahead of Time compiler for numeric kernels"
HOMEPAGE="
	https://pypi.org/project/pythran/
	https://github.com/serge-sans-paille/pythran/
"
SRC_URI="
	https://github.com/serge-sans-paille/pythran/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-libs/boost
	dev-cpp/xsimd
	=dev-python/beniget-0.4*[${PYTHON_USEDEP}]
	=dev-python/gast-0.5*[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-libs/boost
		dev-cpp/xsimd
	)
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/ipython[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
		dev-python/wheel[${PYTHON_USEDEP}]
		virtual/cblas
		!!dev-python/setuptools-declarative-requirements
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_configure() {
	# vendored C++ headers -- use system copies
	rm -r pythran/{boost,xsimd} || die

	if use test ; then
		# https://bugs.gentoo.org/916461
		sed -i \
			-e 's|blas=blas|blas=cblas|' \
			-e 's|libs=|libs=cblas|' \
			pythran/pythran-*.cfg || die
	fi
}

python_test() {
	local -x COLUMNS=80
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
