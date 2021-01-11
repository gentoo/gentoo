# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_P=python-rsa-version-${PV}
DESCRIPTION="Pure-Python RSA implementation"
HOMEPAGE="
	https://stuvel.eu/rsa/
	https://pypi.org/project/rsa/"
SRC_URI="
	https://github.com/sybrenstuvel/python-rsa/archive/version-${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 sparc x86"

RDEPEND="
	>=dev-python/pyasn1-0.1.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests unittest

src_prepare() {
	rm tests/test_mypy.py || die
	distutils-r1_src_prepare
}
