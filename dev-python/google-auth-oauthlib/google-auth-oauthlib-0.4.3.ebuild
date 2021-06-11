# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

MY_P=google-auth-library-python-oauthlib-${PV}
DESCRIPTION="Google Authentication Library"
HOMEPAGE="
	https://pypi.org/project/google-auth-oauthlib/
	https://github.com/googleapis/google-auth-library-python-oauthlib"
SRC_URI="
	https://github.com/googleapis/google-auth-library-python-oauthlib/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/click-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.7.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
DOCS=( LICENSE README.rst )
