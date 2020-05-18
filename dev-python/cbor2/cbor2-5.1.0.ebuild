# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Pure Python CBOR (de)serializer with extensive tag support"
HOMEPAGE="https://github.com/agronholm/cbor2 https://pypi.org/project/cbor2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

RDEPEND="${DEPEND}"

distutils_enable_tests pytest
