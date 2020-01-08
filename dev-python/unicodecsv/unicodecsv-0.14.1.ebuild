# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for python stdlib csv module supporting unicode"
HOMEPAGE="https://pypi.org/project/unicodecsv/ https://github.com/jdunck/python-unicodecsv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	python -m unittest discover
}
