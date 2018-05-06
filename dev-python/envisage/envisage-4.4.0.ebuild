# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# py2.6 fails testsuite horribly
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Extensible application framework"
HOMEPAGE="http://docs.enthought.com/envisage/
	https://github.com/enthought/envisage
	https://pypi.org/project/envisage"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=">=dev-python/traits-4[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/traits-4[${PYTHON_USEDEP}]
		dev-python/apptools[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

# tests are buggy version after version
RESTRICT=test

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake
}
