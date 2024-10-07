# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Reference package for GRPC Python status proto mapping"
HOMEPAGE="
	https://github.com/grpc/grpc/
	https://grpc.io
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/grpcio[${PYTHON_USEDEP}]
	dev-python/googleapis-common-protos[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
"
distutils_enable_tests import-check
