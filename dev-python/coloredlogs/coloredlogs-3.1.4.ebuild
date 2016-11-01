# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Colored stream handler for the logging module"
HOMEPAGE="https://pypi.python.org/pypi/coloredlogs https://github.com/xolox/python-coloredlogs http://coloredlogs.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/humanfriendly-1.42[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/capturer[${PYTHON_USEDEP}]
		dev-python/verboselogs[${PYTHON_USEDEP}]
	)"

DOCS=( README.rst )

PATCHES=( "${FILESDIR}"/${PN}-2.0-skip-cli-test.patch )

python_test() {
	esetup.py test
}
