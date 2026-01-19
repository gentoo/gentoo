# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

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
	<dev-python/httplib2-1[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.19.0[${PYTHON_USEDEP}]
	<dev-python/google-auth-3[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.32.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-localserver )
distutils_enable_tests pytest
