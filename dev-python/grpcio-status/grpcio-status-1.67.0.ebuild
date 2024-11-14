# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=grpc-${PV}
DESCRIPTION="Reference package for GRPC Python status proto mapping"
HOMEPAGE="
	https://grpc.io/
	https://github.com/grpc/grpc/
	https://pypi.org/project/grpcio-status/
"
SRC_URI="
	https://github.com/grpc/grpc/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}/src/python/grpcio_status

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	>=dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
	>=dev-python/googleapis-common-protos-1.5.5[${PYTHON_USEDEP}]
	<dev-python/protobuf-python-6[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-5.26.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	cd "${WORKDIR}/${MY_P}/src/python/grpcio_tests" || die
	epytest tests{,_aio}/status
}
