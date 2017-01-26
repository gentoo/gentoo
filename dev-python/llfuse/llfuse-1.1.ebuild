# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Python bindings for the low-level FUSE API"
HOMEPAGE="https://python-llfuse.googlecode.com/ https://pypi.python.org/pypi/llfuse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND=">=sys-fs/fuse-2.8.0
	$(python_gen_cond_dep 'dev-python/contextlib2[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-catchlog[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
