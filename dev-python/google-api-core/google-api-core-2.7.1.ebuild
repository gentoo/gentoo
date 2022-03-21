# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Core Library for Google Client Libraries"
HOMEPAGE="https://github.com/googleapis/python-api-core/
	https://googleapis.dev/python/google-api-core/latest/index.html"
SRC_URI="https://github.com/googleapis/${PN//google/python}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P//google/python}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

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
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/proto-plus[${PYTHON_USEDEP}]
		dev-python/rsa[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# failing due to missing grpcio-status
	tests/asyncio/test_grpc_helpers_async.py::test_wrap_unary_errors
	tests/asyncio/test_grpc_helpers_async.py::test_wrap_stream_errors_raised
	tests/asyncio/test_grpc_helpers_async.py::test_wrap_stream_errors_read
	tests/asyncio/test_grpc_helpers_async.py::test_wrap_stream_errors_aiter
	tests/asyncio/test_grpc_helpers_async.py::test_wrap_stream_errors_write
	tests/unit/test_grpc_helpers.py::test_wrap_unary_errors
	tests/unit/test_grpc_helpers.py::Test_StreamingResponseIterator::test___next___w_rpc_error
	tests/unit/test_grpc_helpers.py::test_wrap_stream_errors_invocation
	tests/unit/test_grpc_helpers.py::test_wrap_stream_errors_iterator_initialization
	tests/unit/test_grpc_helpers.py::test_wrap_stream_errors_during_iteration
	# TODO
	tests/unit/test_operation.py::test_exception_with_error_code
)

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	epytest -p no:aiohttp -p no:trio
}
