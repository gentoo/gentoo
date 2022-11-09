# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Tool to check the completeness of MANIFEST.in for Python packages"
HOMEPAGE="
	https://github.com/mgedmin/check-manifest
	https://pypi.org/project/check-manifest/
"
SRC_URI="https://github.com/mgedmin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/build[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Need internet
	tests.py::Tests::test_build_sdist_pep517_isolated
)

distutils_enable_tests pytest
