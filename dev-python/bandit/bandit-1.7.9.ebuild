# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A security linter from OpenStack Security"
HOMEPAGE="
	https://github.com/PyCQA/bandit/
	https://pypi.org/project/bandit/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/GitPython-3.1.30[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/beautifulsoup4-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/jschema-to-python-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.9.4[${PYTHON_USEDEP}]
		>=dev-python/sarif-om-1.0.4[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.3.0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
		' 3.10)
	)
"

distutils_enable_tests unittest
