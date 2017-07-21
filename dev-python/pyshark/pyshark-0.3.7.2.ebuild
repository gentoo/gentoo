# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 eutils

DESCRIPTION="A Python wrapper for tshark output parsing"
HOMEPAGE="https://pypi.python.org/pypi/pyshark https://github.com/KimiNewt/pyshark"
# pypi tarball is missing tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/KimiNewt/pyshark/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# See pyshark.egg-info/requires.txt
RDEPEND="
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/logbook[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/trollius[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	net-analyzer/wireshark"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${P}/src"

python_prepare_all() {
	# Test fails unless portage can execute /usr/bin/dumpcap
	# https://github.com/KimiNewt/pyshark/issues/197
	rm "${WORKDIR}/${P}/tests/capture/test_inmem_capture.py" || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${WORKDIR}/${P}/tests" || die
	py.test -v || die
}
