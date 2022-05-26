# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Beautiful, Pythonic protocol buffers"
HOMEPAGE="https://pypi.org/project/proto-plus/ https://github.com/googleapis/proto-plus-python"
SRC_URI="
	https://github.com/googleapis/proto-plus-python/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/google-api-core[${PYTHON_USEDEP}]
		dev-python/grpcio[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

src_prepare() {
	# https://github.com/pytest-dev/pytest/issues/9637#issuecomment-1031997415
	sed -i -e '/staticmethod/d' tests/test_datetime_helpers.py || die
	distutils-r1_src_prepare
}
