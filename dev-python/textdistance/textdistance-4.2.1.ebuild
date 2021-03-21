# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Compute distance between the two texts"
HOMEPAGE="https://github.com/life4/textdistance"
SRC_URI="https://github.com/life4/textdistance/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? (
	dev-python/abydos[${PYTHON_USEDEP}]
	dev-python/hypothesis[${PYTHON_USEDEP}]
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/jellyfish[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/python-levenshtein[${PYTHON_USEDEP}]
	dev-python/pyxDamerauLevenshtein[${PYTHON_USEDEP}]
)"

S="${WORKDIR}/${PN}-v.${PV}"

distutils_enable_tests --install pytest

python_prepare_all() {
	# RuntimeError: cannot import distance.hamming
	# these optional things are missing at the moment
	sed -i -e 's:test_compare:_&:' \
		-e 's:test_qval:_&:' \
		-e 's:test_list_of_numbers:_&:' \
		tests/test_external.py || die

	distutils-r1_python_prepare_all
}
