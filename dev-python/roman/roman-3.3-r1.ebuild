# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="An Integer to Roman numerals converter"
HOMEPAGE="https://pypi.org/project/roman/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests setup.py

python_prepare_all() {
	mv "${S}/src/tests.py" . || die "moving test file failed"
	distutils-r1_python_prepare_all
}
