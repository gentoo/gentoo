# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="pytest plugin: fixtures and code to help with running shell commands on tests"
HOMEPAGE="
	https://pypi.org/project/pytest-shell-utilities/
	https://github.com/saltstack/pytest-shell-utilities/
"
SRC_URI="
	https://github.com/saltstack/pytest-shell-utilities/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/attrs-22.1.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
