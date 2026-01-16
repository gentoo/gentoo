# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

MY_P=google-auth-library-python-oauthlib-${PV}
DESCRIPTION="Google Authentication Library"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python-oauthlib/
	https://pypi.org/project/google-auth-oauthlib/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/click-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.46.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.7.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
