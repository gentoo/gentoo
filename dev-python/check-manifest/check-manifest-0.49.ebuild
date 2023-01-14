# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Tool to check the completeness of MANIFEST.in for Python packages"
HOMEPAGE="
	https://github.com/mgedmin/check-manifest/
	https://pypi.org/project/check-manifest/
"
SRC_URI="
	https://github.com/mgedmin/check-manifest/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/build[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Need internet
	tests.py::Tests::test_build_sdist_pep517_isolated
)

distutils_enable_tests pytest
