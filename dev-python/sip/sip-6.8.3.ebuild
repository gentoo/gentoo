# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Python bindings generator for C/C++ libraries"
HOMEPAGE="https://github.com/Python-SIP/sip/"
# gh does not include a way to generate some files, so combine with pypi
SRC_URI+="
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

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest
