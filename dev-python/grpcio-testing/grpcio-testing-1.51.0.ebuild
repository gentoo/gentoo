# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Testing utilities for gRPC Python"
HOMEPAGE="https://grpc.io"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	~dev-python/grpcio-${PV}[${PYTHON_USEDEP}]
	<dev-python/protobuf-python-5[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-4.21.3[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
