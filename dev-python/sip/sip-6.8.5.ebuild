# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Python bindings generator for C/C++ libraries"
HOMEPAGE="https://github.com/Python-SIP/sip/"
# combine given pypi lacks docs+tests, and gh lacks abi version files
# breaking revdeps if only using SCM_PRETEND_VERSION and would rather
# not attempt to manually handle this
SRC_URI+="
	doc? (
		https://github.com/Python-SIP/sip/archive/refs/tags/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	)
	test? (
		https://github.com/Python-SIP/sip/archive/refs/tags/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	)
"

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' 3.10)
"
BDEPEND="
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/myst-parser \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
