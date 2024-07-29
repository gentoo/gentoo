# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=python-api-core-${PV}
DESCRIPTION="Core Library for Google Client Libraries"
HOMEPAGE="
	https://github.com/googleapis/python-api-core/
	https://pypi.org/project/google-api-core/
	https://googleapis.dev/python/google-api-core/latest/index.html
"
SRC_URI="
	https://github.com/googleapis/python-api-core/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	>=dev-python/googleapis-common-protos-1.56.2[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/proto-plus-1.22.3[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
	!dev-python/namespace-google
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
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
	tests/unit/test_grpc_helpers.py::test_wrap_stream_errors_invocation
	tests/unit/test_grpc_helpers.py::test_wrap_stream_errors_iterator_initialization
	tests/unit/test_grpc_helpers.py::test_wrap_stream_errors_during_iteration
)

python_test() {
	rm -rf google || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio tests
}
