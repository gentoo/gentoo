# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Google Authentication Library"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python/
	https://pypi.org/project/google-auth/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	<dev-python/cachetools-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.2.1[${PYTHON_USEDEP}]
	>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!dev-python/namespace-google
"
BDEPEND="
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/grpcio[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/moto[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/pyu2f[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# these are compatibility tests with oauth2client
	# disable them to unblock removal of that package
	tests/test__oauth2client.py
)

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
