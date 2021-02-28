# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Core Library for Google Client Libraries"
HOMEPAGE="https://github.com/googleapis/python-api-core
	https://googleapis.dev/python/google-api-core/latest"
SRC_URI="https://github.com/googleapis/${PN//google/python}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P//google/python}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/namespace-google[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/googleapis-common-protos[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/grpcio[${PYTHON_USEDEP}]
		dev-python/rsa[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install pytest

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
