# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="An Integer to Roman numerals converter"
HOMEPAGE="https://pypi.org/project/roman/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="!<dev-python/docutils-0.9[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip"

python_test() {
	cp "${S}/src/tests.py" . || die "copying test file failed"
	esetup.py test
}
