# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python bindings for the low-level FUSE API"
HOMEPAGE="https://python-llfuse.googlecode.com/ https://pypi.python.org/pypi/llfuse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=sys-fs/fuse-2.8.0
	dev-python/contextlib2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig"

python_prepare_all() {
	# use system setuptools
	sed -i '/use_setuptools/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
