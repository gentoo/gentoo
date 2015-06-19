# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/guessit/guessit-0.6.2.ebuild,v 1.2 2015/04/08 08:05:01 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="library for guessing information from video files"
HOMEPAGE="http://guessit.readthedocs.org https://github.com/wackou/guessit https://pypi.python.org/pypi/guessit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# FIXME fails tests with python-3.3.2-r2
RESTRICT="test"

python_test() {
	esetup.py test
}
