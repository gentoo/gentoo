# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="An Integer to Roman numerals converter"
HOMEPAGE="https://pypi.python.org/pypi/roman/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="!<dev-python/docutils-0.9[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip"

python_test() {
	cp "${S}/src/tests.py" . || die "copying test file failed"
	esetup.py test
}
