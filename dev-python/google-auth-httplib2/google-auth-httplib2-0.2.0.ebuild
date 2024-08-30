# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P="google-auth-library-python-httplib2-${PV}"
DESCRIPTION="httplib2 Transport for Google Auth"
HOMEPAGE="
	https://pypi.org/project/google-auth-httplib2/
	https://github.com/googleapis/google-auth-library-python-httplib2/
"
SRC_URI="
	https://github.com/googleapis/google-auth-library-python-httplib2/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/google-auth[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
