# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="
	https://github.com/PyGithub/PyGithub/
	https://pypi.org/project/PyGithub/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

# cryptography via pyjwt[crypto]
RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/httpretty-0.9.6[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
