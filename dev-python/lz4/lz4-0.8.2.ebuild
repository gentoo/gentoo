# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="LZ4 Bindings for Python"
HOMEPAGE="https://pypi.python.org/pypi/lz4 https://github.com/steeve/python-lz4"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# Tests still excluded by upstream

python_prepare_all() {
	sed \
		-e '/nose/s:setup_requires:test_requires:g' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
