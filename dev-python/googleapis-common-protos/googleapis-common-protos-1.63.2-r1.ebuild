# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
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
	<dev-python/protobuf-python-6[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.15.0[${PYTHON_USEDEP}]
	!dev-python/namespace-google
"

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

# no tests as this is all generated code
