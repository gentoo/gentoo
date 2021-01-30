# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

DESCRIPTION="Google Authentication Library"
HOMEPAGE="https://pypi.org/project/google-auth-oauthlib/ https://github.com/googleapis/google-auth-library-python-oauthlib"
SRC_URI="mirror://pypi/google-auth-oauthlib/google-auth-oauthlib/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/google-auth[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.7.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
DOCS=( LICENSE README.rst )
