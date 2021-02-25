# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Tools to handle merging of nested data structures in python"
HOMEPAGE="https://deepmerge.readthedocs.io/en/latest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# pypi doesn't ship tests, and last github release is 0.0.5
RESTRICT="test"

python_prepare_all() {
	sed -i -e '/vcver/d' setup.py || die
	distutils-r1_python_prepare_all
}
