# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="
	https://github.com/PyGithub/PyGithub/
	https://pypi.org/project/PyGithub/
"
SRC_URI="
	https://github.com/PyGithub/PyGithub/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		>=dev-python/httpretty-0.9.6[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
