# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/manuel/manuel-1.7.1.ebuild,v 1.11 2015/03/08 23:53:28 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Manuel lets you build tested documentation"
HOMEPAGE="https://github.com/benji-york/manuel/ http://pypi.python.org/pypi/manuel"
# A snapshot was required since upstream missed out half the source
SRC_URI="http://dev.gentoo.org/~idella4/tarballs/${P}-20130316.tar.bz2"

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
