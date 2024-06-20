# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=${PN}-python-${PV}
DESCRIPTION="Beautiful, Pythonic protocol buffers"
HOMEPAGE="
	https://github.com/googleapis/proto-plus-python/
	https://pypi.org/project/proto-plus/
"
SRC_URI="
	https://github.com/googleapis/proto-plus-python/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	<dev-python/protobuf-python-5[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/google-api-core-1.31.5[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
