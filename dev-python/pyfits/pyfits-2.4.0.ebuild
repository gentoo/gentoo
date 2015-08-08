# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"

inherit distutils

DESCRIPTION="Provides an interface to FITS formatted files under python"
SRC_URI="http://www.stsci.edu/resources/software_hardware/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/pyfits"

IUSE=""
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
LICENSE="BSD"

RDEPEND="dev-python/numpy
	!<dev-python/astropy-0.3"
DEPEND="${RDEPEND}"

# current tests need data which are not in tar ball
RESTRICT="test"

src_test() {
	testing() {
		local t
		for t in lib/tests/testPyfits*.py; do
			PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)"  "$(PYTHON)" "${t}" || die "${t} failed with Python ${PYTHON_ABI}"
		done
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	local binary
	for binary in "${ED}"/usr/bin/*; do
		mv ${binary}{,-pyfits} || die
	done
}
