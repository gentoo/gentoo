# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=PyGithub
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="
	https://github.com/PyGithub/PyGithub/
	https://pypi.org/project/PyGithub/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# cryptography via pyjwt[crypto]
RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/responses[${PYTHON_USEDEP}]
		>=dev-python/pytest-subtests-0.11.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
