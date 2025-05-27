# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="The python implementation of the MMTF API, decoder and encoder"
HOMEPAGE="
	https://mmtf.rcsb.org/
	https://github.com/rcsb/mmtf-python/
	https://pypi.org/project/mmtf-python/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/msgpack[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" mmtf/tests/codec_tests.py -v || die "Tests failed with ${EPYTHON}"
}
