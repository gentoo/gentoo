# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Manuel lets you build tested documentation"
HOMEPAGE="https://github.com/benji-york/manuel/ https://pypi.python.org/pypi/manuel"
# A snapshot was required since upstream missed out half the source
SRC_URI="https://dev.gentoo.org/~idella4/tarballs/${P}-20130316.tar.bz2"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
# Required to run tests
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( CHANGES.txt )

PATCHES=( "${FILESDIR}"/${PN}-1.7-rm_zope_test.patch )

python_test() {
	PYTHONPATH=src/ esetup.py test
}
