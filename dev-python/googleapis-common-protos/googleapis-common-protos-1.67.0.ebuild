# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python classes generated from the common protos in the googleapis repository"
HOMEPAGE="
	https://github.com/googleapis/python-api-common-protos/
	https://pypi.org/project/googleapis-common-protos/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	<dev-python/protobuf-6[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
