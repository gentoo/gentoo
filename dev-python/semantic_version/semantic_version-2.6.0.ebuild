# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Python library providing a few tools handling SemVer in Python."
HOMEPAGE="https://pypi.python.org/pypi/semantic_version"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	esetup.py test
}
