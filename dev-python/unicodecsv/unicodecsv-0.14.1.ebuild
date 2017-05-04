# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for python stdlib csv module supporting unicode"
HOMEPAGE="https://pypi.python.org/pypi/unicodecsv https://github.com/jdunck/python-unicodecsv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc x86"
IUSE=""

python_test() {
	python -m unittest discover
}
