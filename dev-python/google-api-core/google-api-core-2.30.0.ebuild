# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=gcp:google-cloud-sdk-py@oss-exit-gate-prod.iam.gserviceaccount.com
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Core Library for Google Client Libraries"
HOMEPAGE="
	https://github.com/googleapis/google-cloud-python/
	https://pypi.org/project/google-api-core/
	https://googleapis.dev/python/google-api-core/latest/index.html
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="grpc"

RDEPEND="
	>=dev-python/googleapis-common-protos-1.56.3[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/proto-plus-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-4.25.8[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
	grpc? (
		>=dev-python/grpcio-1.75.1[${PYTHON_USEDEP}]
		>=dev-python/grpcio-status-1.75.1[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		>=dev-python/grpcio-1.75.1[${PYTHON_USEDEP}]
		>=dev-python/grpcio-status-1.75.1[${PYTHON_USEDEP}]
		dev-python/rsa[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,mock} )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# The grpc_gcp module is missing to perform a stress test
	tests/unit/test_grpc_helpers.py
)

python_test() {
	rm -rf google || die
	epytest tests
}
