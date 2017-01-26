# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="A python library and command-line tool to "prettify" and colorize XML"
HOMEPAGE="https://pypi.python.org/pypi/pxml https://github.com/metagriffin/pxml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/blessings-1.5[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed \
		-e '/distribute/d' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}
