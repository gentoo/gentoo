# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1
# json module required.

DESCRIPTION="Gtk and/or Vim-based Python Integrated Development Application"
HOMEPAGE="http://pida.co.uk/ http://pypi.python.org/pypi/pida"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=app-editors/gvim-6.3[gtk,${PYTHON_USEDEP}]
	>=dev-python/anyvc-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/bpython-0.9.7[gtk,${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.8[${PYTHON_USEDEP}]
	>dev-python/pygtkhelpers-0.4.1[${PYTHON_USEDEP}]
	>=x11-libs/vte-0.11.11-r2:0[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig"

src_prepare() {
	distutils-r1_src_prepare

	# Don't require argparse with Python 2.7.
	sed -e "/argparse/d" -i setup.py || die "sed failed"

	epatch "${FILESDIR}/${PN}-0.6.1-fix_implicit_declaration.patch"
	emake -C contrib/moo moo-pygtk.c
}

src_install() {
	distutils-r1_src_install
	make_desktop_entry pida Pida Development
}
