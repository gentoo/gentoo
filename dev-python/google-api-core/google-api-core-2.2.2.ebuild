# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Core Library for Google Client Libraries"
HOMEPAGE="https://github.com/googleapis/python-api-core/
	https://googleapis.dev/python/google-api-core/latest/index.html"
SRC_URI="https://github.com/googleapis/${PN//google/python}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P//google/python}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	dev-python/namespace-google[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/googleapis-common-protos[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
"
# grpcio support is broken if grpcio-status is not installed,
# and we do not package the latter
BDEPEND="
	test? (
		!!dev-python/grpcio
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/rsa[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install pytest

EPYTEST_DESELECT=(
	# TODO: package proto-plus
	tests/unit/test_protobuf_helpers.py::test_field_mask_ignore_trailing_underscore
	tests/unit/test_protobuf_helpers.py::test_field_mask_ignore_trailing_underscore_with_nesting
)

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
