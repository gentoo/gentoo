# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Yet another boost.python based wrapper for GraphicsMagick"
HOMEPAGE="https://pypi.python.org/pypi/pgmagick/ https://bitbucket.org/hhatto/pgmagick/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="media-gfx/graphicsmagick[cxx]
	dev-libs/boost:=[python,${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		media-fonts/corefonts )"

python_test() {
	# https://bitbucket.org/hhatto/pgmagick/issue/46/
	for test in test/test_*.py; do
		"${PYTHON}" $test
	done
}
