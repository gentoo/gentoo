# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=google-auth-library-python-oauthlib-${PV}
DESCRIPTION="Google Authentication Library"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python-oauthlib/
	https://pypi.org/project/google-auth-oauthlib/
"
SRC_URI="
	https://github.com/googleapis/google-auth-library-python-oauthlib/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/click-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.7.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/googleapis/google-auth-library-python-oauthlib/pull/328
	"${FILESDIR}/${PN}-1.2.0-setup-exclude.patch"
)
