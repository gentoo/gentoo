# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rednose/rednose-0.4.1.ebuild,v 1.4 2015/03/09 00:05:28 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="coloured output for nosetests"
HOMEPAGE="http://gfxmonk.net/dist/0install/rednose.xml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/python-termstyle-0.1.7[${PYTHON_USEDEP}]"
