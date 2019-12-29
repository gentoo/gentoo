# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7,8}} )

inherit distutils-r1

DESCRIPTION="Zstandard Bindings for Python"
HOMEPAGE="https://pypi.org/project/zstandard/ https://github.com/indygreg/python-zstandard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/cffi:=[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"

python_compile() {
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}
