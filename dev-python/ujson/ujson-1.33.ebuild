# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# One test; FAIL: test_encodeToUTF8 (__main__.UltraJSONTests) under py2.5.
# Fix and repair and re-insert if it's REALLY needed
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Ultra fast JSON encoder and decoder for Python"
HOMEPAGE="https://pypi.python.org/pypi/ujson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-test-py3.patch
)

python_test() {
	# See setup.py; line 72. Again "${S}" is used for reading tests
	# Since py3_2 is first in the queue it needs its own copy
	# or else all py2s to follow will be reading read py3 tests
	if [[ "${EPYTHON}" =~ 'python3' ]]; then
		cd "${BUILD_DIR}"/lib || die
		cp -a "${S}"/tests/ .  || die
		2to3 -w tests/tests.py
		"${PYTHON}" tests/tests.py || die
		rm -rf tests/ || die
	else
		"${PYTHON}" tests/tests.py || die
	fi
}
